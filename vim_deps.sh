# This script requires certain lines located in my .vimrc.
# It is not standalone.
# Specifically:
#     - Add bundles to .vimrc for Vundle
#     - Add the followingn to .vimrc for omnicompletion
#         filetype plugin on
#         set omnifunc=syntaxcomplete#Complete


if [[ $(uname) != "Darwin" ]];
then
    echo "This script is for OSX"
    exit
fi

if [[ ! -e /Applications/MacVim.app ]];
then
    echo "MacVim must already be installed in /Applications..."
    exit
fi

echo "Installing linters, node, pip..."
brew install node
npm install -g jshint
sudo easy_install pip
sudo pip install pylint
sudo pip install pep8

mkdir -p ~/.vim/bundle
cd ~/.vim/bundle

echo "Cloning bundle repos..."
git clone git@github.com:gmarik/Vundle.vim
git clone git@github.com:scrooloose/syntastic
git clone git@github.com:Valloric/YouCompleteMe
git clone git@github.com:marijnh/tern_for_vim
git clone git@github.com:Raimondi/delimitMate

cd tern_for_vim
npm install

echo "Installing bundles via Vundle..."
vim +BundleInstall

echo "Compiling modules for YouCompleteMe"
# instructions from https://valloric.github.io/YouCompleteMe/
brew install cmake
cd ~
mkdir ycm_build; cd ycm_build
mkdir clangdir; cd clangdir
curl -O http://llvm.org/releases/3.4.2/clang+llvm-3.4.2-x86_64-apple-darwin10.9.xz
tar xzf clang+llvm-3.4.2-x86_64-apple-darwin10.9.xz
cd ..
cmake -G "Unix Makefiles" \
    -DPATH_TO_LLVM_ROOT=~/ycm_build/clangdir/clang+llvm-3.4.2-x86_64-apple-darwin10.9 . \
    ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
# if this fails, try brew install --with-clang --all-targets --rtti --universal --jit llvm (will take a while)
make ycm_support_libs


# This is necessary for YouCompleteMe on OSX. We need a Vim binary that's
# 7.4 or greater, and that has python support compiled in. It's easiest to just
# use whatever comes bundles with MacVim.
echo "mapping vi command to MacVim Vim binary..."
cd /Applications/MacVim.app/Contents/MacOS/
ln -s MacVim vi
echo "PATH=/Applications/MacVim.app/Contents/MacOS/:$PATH" >> ~/.bash_profile

