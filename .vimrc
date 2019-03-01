if !has('nvim')
    set term=xterm-256color
endif
if has('nvim')
endif

set t_Co=256
set background=dark
" pyte is a GUI only colorscheme, so use molokai instead if we're in a terminal
if !has('gui_running')
     colorscheme solarized
     let g:solarized_termcolors=256
else
    colorscheme pyte
    set transparency=4
endif
syntax enable
set guifont=Fira\ Mono:h11

" =============== plugins ===================
call plug#begin('~/.vim/plugged')

" ---------------- Golang ---------------

Plug 'cloudhead/neovim-fuzzy'
Plug 'scrooloose/nerdtree'
Plug 'fatih/vim-go'
Plug 'godoctor/godoctor.vim'
Plug 'w0rp/ale'
Plug 'ctrlpvim/ctrlp.vim'

if !has('nvim')
    Plug 'maralla/completor.vim'
endif
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'zchee/deoplete-go', { 'do': 'make' }
    Plug 'jodosha/vim-godebug'

    let g:deoplete#enable_at_startup = 1
    let g:min_pattern_length = 1

    " Use TAB to cycle through completions
    imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    " imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>\<Plug>AutoPairsReturn"
endif

let g:go_auto_type_info = 1

" Does this work?
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

let g:go_fmt_command = "goimports"

let g:ale_sign_error = 'X'
let g:ale_sign_warning = 'W'

au FileType go nnoremap <leader>gs :GoDeclsDir<cr>
au FileType go nnoremap <leader>gu :GoDeclsDir ..<cr>

au FileType go nnoremap <leader>gds :GoDefStack<cr>
au FileType go nnoremap <leader>gdp :GoDefPop<cr>
au FileType go nnoremap <leader>gdc :GoDefClear<cr>

au FileType go nnoremap <leader>gb :GoTest<cr>
au FileType go nnoremap <leader>gt :GoTest<cr>
au FileType go nnoremap <leader>gf :GoTestFunc<cr>

au Filetype go nnoremap <leader>ga :GoAlternate<cr>

" ---------------- end Golang ---------------

Plug 'tpope/vim-fugitive'

call plug#end()

" =============== vim-go ===================

set number
set relativenumber
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
" remove right scrollbar in macvim
set guioptions-=r
" remove left scrollbar in macvim
set go-=L

" Find root dir tag file
set tags=tags;/

:let mapleader = "\<Space>"
noremap ; :
noremap : ;
" save on exiting insert mode, mostly to trigger Syntastic
inoremap jk <Esc>:w<cr>
" normal insert exit, no save trigger
inoremap jw <Esc>
inoremap JK <Esc>
cnoremap jk <Esc>
inoremap j; <Esc>A;<Esc>
inoremap j, <Esc>A,<Esc>
nnoremap <leader>, :noh<cr>
" quick save/quit
nnoremap <leader>w :w<cr>
nnoremap <leader>nw :w!<cr>
nnoremap <leader>q :wq<cr>
nnoremap <leader>nq :q!<cr>
nnoremap <leader>zf :set foldmethod=syntax<cr>
nnoremap <leader>zn :set nofoldenable<cr>
" Delete line and insert on same line (to get indentation)
nnoremap <leader>e "_ddO
" Make ci( and ci{ behave like ci", which jumps to the first " in the line
nnoremap ci( f(ci(
nnoremap ci) f)ci)
nnoremap ci{ f{ci{
nnoremap ci} f}ci}
" Add semicolon to end of line
nnoremap <leader>; A;<Esc>
" Make Y behave like D (copy until end of line, not whole line)
nnoremap Y y$
" Paste at end of line shortcut
nnoremap <leader>yp $p
" Increment number shortcut
nnoremap <leader>a <C-a>
" insert newline
nnoremap <leader><cr> i<cr><Esc>
" Toggle caps of whole word
nnoremap <leader>` :set tildeop<cr>:set iskeyword+=_<cr>~wel:set iskeyword-=_<cr>:set notildeop<cr>
" Quick paste
nnoremap <leader>sp :set paste<cr>:r!pbpaste<cr>:set nopaste<cr>
" Quick paste of 0 buffer
nnoremap <leader>pp "0p
nnoremap <leader>pP "0P
" Repeat/browse last colon command shortcuts
nnoremap <leader>rq q:k<CR>
nnoremap <leader>rl q:k
" Show vim cheat sheet
nnoremap <leader>ch :sp ~/.vim/cheat_sheet<cr>
" open ~/.vimrc in vsplit
nnoremap <leader>vv :vsplit ~/.vimrc<cr>
" source ~/.vimrc file
nnoremap <leader>sv :source ~/.vimrc<cr>
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
nnoremap <leader>9 f(l
nnoremap <leader>0 t)
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
" Use these for other things
" nnoremap <leader>9 :b9<cr>
" nnoremap <leader>0 :b10<cr>
nnoremap <leader>b <C-^>
" quick setup for changing buffer manually
" nnoremap <leader>f :b
nnoremap <leader>ff :ls<cr>:b
" Location list shortcuts, use with :TernRef, and syntastic
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>ll :lclose<cr>
nnoremap <leader>lj :lnext<cr>
nnoremap <leader>lk :lprev<cr>
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

" ======== Syntastic ========
" let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list=1
" let g:syntastic_auto_loc_list = 1

" ======== vim-auto-save ========
let g:auto_save = 0  " disable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_events = ["TextChanged"]
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option

" ======== Ctrl-p =========
nnoremap <leader>cp :FuzzyOpen<cr>
nnoremap <C-g> :FuzzyGrep
" Use regexp mode by default
"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/ovffiles/*,*/coverage/*,*/build/*

" ======== Yankring =========
" Requires all references to g:yankring_replace_n_pkey be commented out in
" yankring.vim. Also, all references to g:yankring_replace_n_nkey should be
" commented out so that <C-n> works for split pane switching.
" nnoremap <C-y> :YRShow<cr>

" ======== NERDTree settings ========
nnoremap <leader>ne :NERDTree<cr>
nnoremap <leader>nr :NERDTree ~/repos/<cr>
nnoremap <leader>ns :NERDTree ~/repos/
nnoremap <leader>nc :NERDTreeClose<cr>

" ======== hound.vim settings ========
let g:hound_base_url = "10.240.16.115"
let g:hound_port = "6880"
let g:hound_vertical_split = 1
let g:hound_ignore_case = 1
nnoremap <leader>h :Hound<space>

" ======== vim-multiple-cursors settings ========
let g:multi_cursor_next_key='<C-i>'
let g:multi_cursor_quit_key='<C-j>'

" ======== general macros/commands ========
" quick enter global search
nnoremap <leader>se :%s/
" Add one blank line of space below
nnoremap <leader>o ok
" Search for debugger statements in node.js
nnoremap <leader>fd /debugger<cr>
" Remove all debugger statements in node.js
nnoremap <leader>fg :%s/\n.*debugger;$//g<cr>:w<cr>
" Convert javascript objects to json syntax
let j=":%s/\(^\s*\)\(\w\)/\1\"\2:%s/\(\w\):/\1\"::%s/\'/\""
" remove trailing whitespace on saves
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.sh :%s/\s\+$//e
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
" The one below breaks pressing tab in insert mode when sourcing .vimrc
" inoremap <C-i> {});ko
inoremap <C-k> {}ko
inoremap <C-f> function()<Space>{}k$F(a
inoremap <C-l> function()<Space>{}k$F(a
