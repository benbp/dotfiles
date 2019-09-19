set -x
set -e

sudo apt-get update
# Common packages
sudo apt install -y apt-transport-https lsb-release dirmngr

# Repositories

# Azure
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv --keyserver packages.microsoft.com \
	--recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF
# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

# k8s Packages
sudo apt install -y apt-transport-https ca-certificates software-properties-common curl
sudo apt install -y docker-ce
sudo apt install -y tmux
sudo snap install kubectl --classic
sudo snap install helm --classic

# Azure packages
sudo apt install -y azure-cli

# Go
sudo snap install go --classic
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install -y neovim
pip3 install --user pynvim
pip3 install --user neovim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
go get github.com/derekparker/delve/cmd/dlv
mkdir -p ~/.vim/colors
wget https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim -O ~/.vim/colors/solarized.vim
echo "====== Update neovimrc link to vimrc ======="

# Repos
git config --global user.email "bebroder@microsoft.com"
git config --global user.name "Ben Broderick Phillips"
git config --global core.editor vim
git config --global core.autocrlf input
read -p "Add aks vsts redirects to git config"
read -p "Copy vsts pub/private keys to ~/.ssh/id_rsa.vsts[.pub]"
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa.vsts

# Dotfiles
wget https://raw.githubusercontent.com/benbp/dotfiles/master/.inputrc -O ~/.inputrc
wget https://raw.githubusercontent.com/benbp/dotfiles/master/.bashrc -O ~/.bashrc
wget https://raw.githubusercontent.com/benbp/dotfiles/master/.vimrc -O ~/.vimrc
wget https://raw.githubusercontent.com/benbp/dotfiles/master/.tmux.conf -O ~/.tmux.conf

# neovim setup
npm install -g neovim
# Do all coc.vim installs
