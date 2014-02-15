set t_Co=256
" colorscheme solarized
" let g:solarized_termcolors=256
" set background=light
" colorscheme jellybeans
" colorscheme moria
" colorscheme ashen
" colorscheme desert256
" colorscheme zenburn
colorscheme molokai
" let g:molokai_original = 1

filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
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

" Fold functions
:set foldmethod=syntax

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
nnoremap <leader>q ZZ
" delete line until semicolon
nnoremap <leader>; dt;
" go to declaration of above function
nnoremap <leader>u ?^\<.*\>\s\<.*\>(.*[:,}]<cr>:noh<cr>z<cr>
" insert space
nnoremap <leader><leader> i<Space><Esc>
" insert newline
nnoremap <leader><cr> i<cr><Esc>
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
" quick open shell
nnoremap <leader>sh :sh<cr>
" redraw
nnoremap <leader>r :redraw!<cr>
" quick open ConqueTerm shell
nnoremap <leader>v :ConqueTermVSplit bash<cr>
nnoremap <leader>hv :ConqueTermSplit bash<cr>

" ======== Pathogen =========
" execute pathogen#infect()

" ======== Syntastic ========
" let g:syntastic_check_on_open=1
" let g:syntastic_enable_signs=1

" ======== Yankring =========
" Requires all references to g:yankring_replace_n_pkey be commented out in
" yankring.vim. Also, all references to g:yankring_replace_n_nkey should be
" commented out so that <C-n> works for split pane switching.
nnoremap <C-p> :YRShow<cr>

" ======== NERDTree settings ========
nnoremap <leader>ne :NERDTree<cr>
nnoremap <leader>nn :NERDTree ~/nebula_repos/<cr>
nnoremap <leader>na :NERDTree ~/nebula_repos/
nnoremap <leader>nc :NERDTreeClose<cr>

" ======== ConqueTerm settings ========
" no terminal colors
let g:ConqueTerm_FastMode = 0
let g:ConqueTerm_StartMessages = 1

" ======== PyLint ========
autocmd FileType python compiler pylint
let g:pylint_onwrite = 0
nnoremap <leader>l :w<cr>:Pylint<cr><C-w>k:redraw!<cr>

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
autocmd FileType python nnoremap <buffer> <leader>co @='I#<c-v><esc>j'<cr>
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
nnoremap <leader>g :w<cr>Go-=-=-<esc>:r !gcc %<cr>?-=-=-<cr>dG:new<cr>p<c-w>j
" close gcc error split window
nnoremap <leader>xx <c-w>k:q!<cr>
" run ./a.out
nnoremap <leader>e :!./a.out<cr>
" Basic template for C files, stored in register c
let @c = 'i#include <stdio.h>#include <stdlib.h>int main(){}ki	'
" printf template
nnoremap <leader>p oprintf("\n");F\
" quick add curly braces
" nnoremap <leader>bk A{}ko
inoremap <C-k> {}ko

" ======= Go macros/commands ========
nnoremap <leader>g :w<cr>:!go run %<cr>
