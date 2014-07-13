" =========== BEGIN VUNDLE =============
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Autocompletion
Bundle 'Valloric/YouCompleteMe'

" Tern for vim
Bundle 'marijnh/tern_for_vim'

" Bracket completion
Bundle 'Raimondi/delimitMate'

" Linters
Bundle 'scrooloose/syntastic'

" Better yank buffers
Plugin 'vim-scripts/YankRing.vim'

" File fuzzy search
Plugin 'kien/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"
"
" =========== END VUNDLE =============
"
set t_Co=256
" colorscheme solarized
" let g:solarized_termcolors=256
" set background=light
colorscheme pyte
" colorscheme jellybeans
" colorscheme moria
" colorscheme ashen
" colorscheme desert256
" colorscheme zenburn
" colorscheme molokai
" let g:molokai_original = 1
"

filetype plugin on
set omnifunc=syntaxcomplete#Complete

filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
" This is enabled above via Vundle
filetype plugin indent on
syntax on
autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd FileType go set noexpandtab
autocmd FileType go compiler go
filetype indent on

set number
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set softtabstop=4
set hlsearch
set autoindent smartindent
set smarttab
set scrolloff=0
set nowrap
set ls=2
" set textwidth=79
set colorcolumn=80
set incsearch
set gdefault
set ruler
set ignorecase
set history=1000
set undolevels=1000
set nobackup
set wildmenu

" Fold functions
" :set foldmethod=syntax

" Find root dir tag file
set tags=tags;/

:let mapleader = "\<Space>"
noremap ; :
noremap : ;
inoremap jk <Esc>
inoremap JK <Esc>
cnoremap jk <Esc>
nnoremap <leader>, :noh<cr>
" quick save/quit
nnoremap <leader>w :w<cr>
nnoremap <leader>nw :w!<cr>
nnoremap <leader>q :wq<cr>
nnoremap <leader>nq :q!<cr>
"  Add semicolon to end of line
nnoremap <leader>; A;<Esc>
" Make Y behave like D (copy until end of line, not whole line)
nnoremap Y y$
" Paste at end of line shortcut
nnoremap <leader>yp $p
" Increment number shortcut
nnoremap <leader>a <C-a>
" insert space
nnoremap <leader><leader> i<Space><Esc>
" insert newline
nnoremap <leader><cr> i<cr><Esc>
" Toggle caps of whole word
nnoremap <leader>` :set tildeop<cr>:set iskeyword+=_<cr>~wel:set iskeyword-=_<cr>:set notildeop<cr>
" Quick paste
nnoremap <leader>sp :set paste<cr>:r!pbpaste<cr>:set nopaste<cr>
" Set paste
nnoremap <leader>ps :set paste<cr>
" Set nopaste
nnoremap <leader>pn :set nopaste<cr>
" Show vim cheat sheet
nnoremap <leader>ch :sp ~/.vim/cheat_sheet<cr>
" open ~/.vimrc in vsplit
nnoremap <leader>vv :vsplit $MYVIMRC<cr>
" source ~/.vimrc file
nnoremap <leader>sv :source $MYVIMRC<cr>
" faster vertical split screen
nnoremap <bar> :vsp<cr>
" faster file open
nnoremap <Bslash> :e .<cr>
" Window level cd to path of current file
autocmd BufEnter * silent! lcd %:p:h
" faster vertical split resize
nnoremap <leader>/ <C-w>>
nnoremap <leader>. <C-w><
" easier split screen navigation
nnoremap <C-h> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-m> <C-w>k
nnoremap <C-l> <C-w>l
" Tab left and right
nnoremap <S-right> gt
nnoremap <S-left> gT
" jump 10 lines up/down
nnoremap <C-k> 10k
nnoremap <C-j> 10j
" quick tag search
" nnoremap <leader>t :ta<Space>
" delete to black hole buffer
nnoremap <leader>d "_dd
" fast buffer switching
nnoremap <leader>1 :b1<cr>
nnoremap <leader>2 :b2<cr>
nnoremap <leader>3 :b3<cr>
nnoremap <leader>4 :b4<cr>
nnoremap <leader>5 :b5<cr>
nnoremap <leader>6 :b6<cr>
nnoremap <leader>7 :b7<cr>
nnoremap <leader>8 :b8<cr>
nnoremap <leader>9 :b9<cr>
nnoremap <leader>0 :b10<cr>
nnoremap <leader>b <C-^>
" quick setup for changing buffer manually
" nnoremap <leader>f :b
nnoremap <leader>f :ls<cr>:b
" Quickfix shortcuts, use with fugitive :Ggrep
nnoremap <leader>cco :copen<cr>
nnoremap <leader>ccl :cclose<cr>
nnoremap <leader>c1 :cc1<cr>
nnoremap <leader>c2 :cc2<cr>
nnoremap <leader>c3 :cc3<cr>
nnoremap <leader>c4 :cc4<cr>
nnoremap <leader>c5 :cc5<cr>
nnoremap <leader>c6 :cc6<cr>
nnoremap <leader>c7 :cc7<cr>
nnoremap <leader>c8 :cc8<cr>
nnoremap <leader>c9 :cc9<cr>
nnoremap <leader>c0 :cc0<cr>
" Location list shortcuts, use with :TernRef
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>ll :lclose<cr>
nnoremap <leader>l1 :ll1<cr>
nnoremap <leader>l2 :ll2<cr>
nnoremap <leader>l3 :ll3<cr>
nnoremap <leader>l4 :ll4<cr>
nnoremap <leader>l5 :ll5<cr>
nnoremap <leader>l6 :ll6<cr>
nnoremap <leader>l7 :ll7<cr>
nnoremap <leader>l8 :ll8<cr>
nnoremap <leader>l9 :ll9<cr>
nnoremap <leader>l0 :ll0<cr>
" Save session shortcut
nnoremap <leader>ms :mksession! ~/curr.vim<cr>
" quick open shell
if has("gui_macvim")
    nnoremap <leader>sh :!open /Applications/iTerm.app<cr>
else
    nnoremap <leader>sh :sh<cr>
endif
nnoremap ! :!
" redraw
nnoremap <leader>r :redraw!<cr>

" ======= YouCompleteMe ========
" http://oli.me.uk/2013/06/29/equipping-vim-for-javascript/
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" ======== Tern ========
nnoremap <leader>tt :TernType<cr>
nnoremap <leader>td :TernDef<cr>
nnoremap <leader>ts :TernDefSplit<cr>
nnoremap <leader>tp :TernDefPreview<cr>
nnoremap <leader>tn :TernRename<cr>
nnoremap <leader>tu :TernRefs<cr>

" ======== Fugitive =========
nnoremap <leader>g :Ggrep<Space>
set laststatus=2
set statusline=%<%f\%{fugitive#statusline()}%m\ %h%r%=%b\ 0x%B\ \ %l,%c%V\ %P\ of\ %L

" ======== Syntastic ========
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1

" ======== Ctrl-p =========
nnoremap <C-p> :CtrlP<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <C-n> :CtrlP ~/renasar_repos<cr>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" ======== Yankring =========
" Requires all references to g:yankring_replace_n_pkey be commented out in
" yankring.vim. Also, all references to g:yankring_replace_n_nkey should be
" commented out so that <C-n> works for split pane switching.
nnoremap <C-y> :YRShow<cr>

" ======== NERDTree settings ========
nnoremap <leader>ne :NERDTree<cr>
nnoremap <leader>nr :NERDTree ~/renasar_repos/<cr>
nnoremap <leader>ns :NERDTree ~/renasar_repos/
nnoremap <leader>nc :NERDTreeClose<cr>

" ======== Groovy syntax for Gradle =========
au BufNewFile,BufRead *.gradle setf groovy
" ======== Yaml syntax =========
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
" ======== Pelican markdown =========
autocmd BufNewFile *.md r ~/.vim/pelican.md

" ======== general macros/commands ========
" quick enter global search
nnoremap <leader>se :%s/
" Add one blank line of space below
nnoremap <leader>o ok
" remove trailing whitespace on saves
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.c :%s/\s\+$//e
autocmd BufWritePre .vimrc :%s/\s\+$//e
" Program specific quick comments, can be done N number of times
autocmd FileType python nnoremap <buffer> <leader>co @='0i#<c-v><esc>j'<cr>
autocmd FileType c nnoremap <buffer> <leader>co @='I//<c-v><esc>j'<cr>
" un-comment, can be done N number of times
autocmd FileType python nnoremap <buffer> <leader>uc @=':s/#//<c-v><cr>j'<cr>
autocmd FileType c nnoremap <buffer> <leader>uc @=':s/\/\///<c-v><cr>j'<cr>
" quick add multi-line comment, including current line
autocmd FileType python nnoremap <buffer> <leader>mc 0i"""o"""kA
autocmd FileType c nnoremap <buffer> <leader>mc 0i/*o*/kA

" ======== HTML macros/commands ========
" call an applescript on save (e.g., the script reloads a web page)
" nnoremap <leader>r :w<cr>:silent ! osascript ./real_time_html.scpt &<cr>:redraw!<cr>

" ======== C macros/commands ========
" -------- put these into an autocmd grouping --------
" gcc compile working file, open errors/warnings in new split
" nnoremap <leader>g :w<cr>Go-=-=-<esc>:r !gcc %<cr>?-=-=-<cr>dG:new<cr>p<c-w>j
" close gcc error split window
" nnoremap <leader>xx <c-w>k:q!<cr>
" run ./a.out
" nnoremap <leader>e :!./a.out<cr>
" Basic template for C files, stored in register c
" let @c = 'i#include <stdio.h>#include <stdlib.h>int main(){}ki	'
" quick add curly braces
" nnoremap <leader>bk A{}ko
" inoremap <C-k> {}ko

" ======= Go macros/commands ========
" nnoremap <leader>g :w<cr>:!go run %<cr>

" ======= Javascript macros/commands ========
" type function() shortcuts
inoremap <C-i> {});ko
inoremap <C-k> {}ko
inoremap <C-f> function()<Space>{}k$F(a
inoremap <C-l> function()<Space>{});k$F(a

