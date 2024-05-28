if !has('nvim')
    set term=xterm-256color
endif
if has('nvim')
endif

" =============== plugins ===================
call plug#begin('~/.vim/plugged')

syntax enable
set guifont=Iosevka\ Term:h11
Plug 'nordtheme/vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'

" Vim line send -> tmux commands
Plug 'jpalardy/vim-slime'
let g:slime_target = "tmux"


" ---------------- TreeSitter ---------------
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" -------------------------------------------

" Plug 'cloudhead/neovim-fuzzy'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Must be set before ctrlp invoked
if exists("g:ctrlp_user_command")
    unlet g:ctrlp_user_command
endif
let g:ctrlp_custom_ignore = 'session-records|test-recordings|\v[\/](\.git|\.hg|\.svn|\.settings|\.sass-cache|cache|\.rsync_cache|vendor/([^\/]+\/)*vendor)$'
" Use regexp mode by default
set wildignore+=*\\vendor\\**
Plug 'ctrlpvim/ctrlp.vim'
Plug 'bling/vim-airline'

" airline statusline edits
" let g:airline_section_b = ''
let g:airline_section_b = ''
let g:airline_section_c = "%{expand('%:p:h:t')}/%t"
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

Plug 'tpope/vim-fugitive'
call plug#end()

" ======== Colors ========
set t_Co=256
set background=dark
" set background=light
" colorscheme "ron"
colorscheme nord

" ======== General settings========
set number
" set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set softtabstop=4
set hlsearch
set autoindent smartindent
set smarttab
set scrolloff=0
set wrap
" If wrap is enabled, make it better
set breakat=\   "keep comment here to prevent whitespace trimming since wrap is on space
set breakindent
set breakindentopt=shift:4
set linebreak
set ls=2
set textwidth=0
set colorcolumn=120
set incsearch
set gdefault
set ruler
set ignorecase
set history=1000
set undolevels=1000
set nobackup
set wildmenu

" Currently certain lsp warnings require prompt, so override cmdheight to 2 to fix
set cmdheight=2

if has('nvim')
    set inccommand=nosplit
endif

if has("nvim")
  " Make escape work in the Neovim terminal.
  tnoremap <Esc> <C-\><C-n>
endif

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
" Traverse wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap <leader>, :noh<cr>
" quick save/quit
nnoremap <leader>w :w<cr>
nnoremap <leader>nw :w!<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>nq :q!<cr>
nnoremap <leader>zf :set foldmethod=syntax<cr>
nnoremap <leader>zo :set nofoldenable<cr>
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
" make n always search forward and N backward
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
" make ; always "find" forward and , backward
nnoremap <expr> : getcharsearch().forward ? ';' : ','
nnoremap <expr> , getcharsearch().forward ? ',' : ';'
" Paste at end of line shortcut
nnoremap <leader>yp $p
" Increment number shortcut
nnoremap <leader>a <C-a>
" insert newline
nnoremap <leader><cr> i<cr><Esc>
" Toggle caps of whole word
nnoremap <leader>` :set tildeop<cr>:set iskeyword+=_<cr>~wel:set iskeyword-=_<cr>:set notildeop<cr>
" Quick paste
nnoremap <leader>sp :set paste<cr>
nnoremap <leader>snp :set nopaste<cr>
" Quick paste of 0 buffer
nnoremap <leader>pp "0p
nnoremap <leader>pP "0P
" Repeat/browse last colon command shortcuts
nnoremap <leader>rq q:k<CR>
nnoremap <leader>rl q:k
" Show vim cheat sheet
nnoremap <leader>ch :sp ~/.vim/cheat_sheet<cr>
" open ~/.vimrc in vsplit
nnoremap <leader>vv :tabnew ~/.vimrc<cr>
" source ~/.vimrc file
nnoremap <leader>sv :source ~/.vimrc<cr>
" faster vertical split screen
nnoremap <bar> :vsp<cr>
" faster file open
nnoremap <Bslash> :e .<cr>
" Window level cd to path of current file
autocmd BufEnter * silent! lcd %:p:h
" faster vertical split resize
nnoremap <leader>/ 10<C-w>>
nnoremap <leader>. 10<C-w><
" easier split screen navigation
nnoremap <C-h> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-m> <C-w>k
" Force C-m override, not to be confused with <cr>
nnoremap  <C-w>k
nnoremap <C-l> <C-w>l
" Tab left and right
nnoremap <S-right> gt
nnoremap <S-left> gT
nnoremap gl gt
nnoremap gh gT
nnoremap gn :tabnew<cr>
nnoremap ge <C-w>T
nnoremap <leader>tt :tab split<cr>
" jump 10 lines up/down
nnoremap <C-k> 10k
nnoremap <C-j> 10j
nnoremap <C-i> 10k
nnoremap <C-u> 10j
" function argument navigation shortcuts
nnoremap <leader>9 f(l
nnoremap <leader>0 t)
nnoremap ) t)
nnoremap ( f(l
" delete to black hole buffer
nnoremap <leader>d "_d
" fast buffer switching
nnoremap <leader>1 :b1<cr>
nnoremap <leader>2 :b2<cr>
nnoremap <leader>3 :b3<cr>
nnoremap <leader>4 :b4<cr>
nnoremap <leader>5 :b5<cr>
nnoremap <leader>6 :b6<cr>
nnoremap <leader>7 :b7<cr>
nnoremap <leader>8 :b8<cr>
nnoremap <leader>b <C-^>
" ======== Ctrl-p =========
nnoremap <leader>ff :Buffers<cr>
nnoremap <leader>fl :CtrlPLine<cr>
nnoremap <leader>fo :CtrlP .<cr>
nnoremap <leader>fm :CtrlPMRUFiles<cr>
nnoremap <leader>cp :CtrlP<cr>
nnoremap <leader>cy :CtrlP ./eng<cr>
" https://github.com/junegunn/fzf.vim/issues/837
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
nnoremap <leader>gg :GGrep<cr>
" Save session shortcut
" nnoremap <leader>ks :mksession! ~/.vim/sessions/curr.vim<cr>
nnoremap ! :!
" Replace end with yank register
nnoremap <leader>u vE"0p

" ======== vim-auto-save ========
let g:auto_save = 0  " disable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_events = ["TextChanged"]
let g:auto_save_no_updatetime = 1  " do not change the 'updatetime' option

" ======== NERDTree settings ========
" nnoremap <leader>ne :NERDTreeFind<cr>
nnoremap <leader>nc :NERDTreeClose<cr>
" Open nerdtree in window. Set a global mark to go back to original file.
nnoremap <leader>ne mE:e .<cr>
let g:NERDTreeHijackNetrw=1

" ======== vim-multiple-cursors settings ========
let g:multi_cursor_next_key='<C-i>'
let g:multi_cursor_quit_key='<C-j>'

" ======== general macros/commands ========
" quick enter global search
nnoremap <leader>se :%s/
" quick enter global search, with abolish.vim
nnoremap <leader>sc :%S/
" quick enter search/ex
" nnoremap <leader>g :g/
" Add one blank line of space below
nnoremap <leader>oo ok

" remove trailing whitespace on saves
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.sh :%s/\s\+$//e
autocmd BufWritePre *.c :%s/\s\+$//e
autocmd BufWritePre *.cs :%s/\s\+$//e
autocmd BufWritePre *.go :%s/\s\+$//e
autocmd BufWritePre *.yaml :%s/\s\+$//e
autocmd BufWritePre *.yml :%s/\s\+$//e
autocmd BufWritePre *.json :%s/\s\+$//e
autocmd BufWritePre *.tpl :%s/\s\+$//e
autocmd BufWritePre .vimrc :%s/\s\+$//e

" yaml indentation
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

" ======= dotnet =======
" Use windows binaries through WSL
let g:OmniSharp_translate_cygwin_wsl = 1
