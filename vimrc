" Auto-installs https://github.com/junegunn/vim-plug
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load plugins
call plug#begin()
Plug 'easymotion/vim-easymotion'                    " <c-j> / <c-k>
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf
Plug 'junegunn/fzf.vim'                             " fzf commands
Plug 'machakann/vim-highlightedyank'                " highlight yanked text
Plug 'tpope/vim-commentary'                         " motions related to comments, e.g. gcc
Plug 'tpope/vim-fugitive'                           " git commands
Plug 'tpope/vim-sleuth'                             " figure shiftwidth/expandtab from context / .editorconfig
Plug 'tpope/vim-surround'                           " motions related to surrounding, e.g. cs'`
Plug 'tpope/vim-vinegar'                            " better netrw
Plug 'yegappan/lsp'                                 " lsp
call plug#end()

set nocompatible                                " Use VIM defaults, not VI
set encoding=utf-8                              " Use UTF-8
set cursorline                                  " Highlight current line
filetype plugin on                              " Detect filetypes and apply configs for filetype
syntax on                                       " Enable syntax highlight
set termguicolors                               " Our terminal supports 24 bit colors
set background=dark                             " We use dark background
colorscheme nord                                " Colorscheme: nord
set cc=120                                      " Vertical line at column 120
set updatetime=300                              " Having longer updatetime (default is 4000 ms) leads to noticeable delays
set signcolumn=yes                              " Always show signcolumn, otherwise it will shift the text when diagnostics appear
set re=0                                        " Use new regex engine, required for faster syntax highlight for TypeScript
set backspace=indent,eol,start                  " Sane backspace
set hlsearch                                    " Highlight search term
set belloff=all                                 " Disable bell sounds
set scrolloff=10                                " Number of lines to keep above/below cursor while scrolling
set tabstop=8                                   " Show actual tabs as 8 spaces
set softtabstop=4                               " Use 4 spaces when typing <TAB> by default
set shiftwidth=4                                " Default indentation level is 4 columns
set expandtab                                   " Insert spaces instead of tabs when indenting
set list                                        " Show whitespace
set listchars+=tab:»\                           " How to display tabs
set listchars+=trail:·                          " How to display trailing spaces
set listchars+=nbsp:␣                           " How to display NBSP
set listchars-=eol:$                            " Do not display EOL
set guicursor=a:block-nCursor                   " Always use block cursor
set noundofile                                  " Do not persist undo history
set noswapfile                                  " Do not create swap files
set nobackup                                    " Do not create backup files
set number                                      " Line numbers
set relativenumber                              " Relative line numbers
let mapleader = ' '                             " Set leader to space
let g:typescript_host_keyword = 0               " Do not try to be smart about TypeScript names
let g:highlightedyank_highlight_duration = 100  " Highlight yanked text

" Remove search highlight on <c-l>
nnoremap <c-l> :nohlsearch<cr><c-l>

" LSP
" LSP Servers are configured on vimrc_win / vimrc_mac / vimrc_linux
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)
nnoremap <silent> [g :LspDiag prev<cr>
nnoremap <silent> ]g :LspDiag next<cr>
nnoremap <silent> <leader>q :LspDiag show<cr>
nnoremap <silent> grd :LspGotoDefinition<cr>zt
nnoremap <silent> grr :LspShowReferences<cr>
nnoremap <silent> grn :LspRename<cr>
nnoremap <silent> gra :LspCodeAction<cr>
nnoremap <silent> K :LspHover<cr>
xnoremap <leader>f :LspFormat<cr>
nnoremap <leader>f :LspFormat<cr>
nnoremap <leader>sf :Files<cr>
vnoremap <leader>y "+y
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
vnoremap <leader>Y "+Y
nnoremap <leader>Y "+Y
vnoremap <leader>y "+y
vnoremap <leader>p "+p
nnoremap <leader>p "+p
vnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>P "+P
vnoremap <leader>P "+P

" Navigation
nnoremap H ^
nnoremap L $
vnoremap H ^
vnoremap L $
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Duplicate and comment
nnoremap yc yy<cmd>normal gcc<cr>p

" Easy Motion
nnoremap <c-j> <plug>(easymotion-j)
nnoremap <c-k> <plug>(easymotion-k)

" Copy current file path to system's clipboard (bc = buffer copy)
nnoremap <leader>bc <cmd>let @+=@%<cr><cmd>echo 'Copied file path: ' . @%<cr>

" F5 reloads vimrc
nnoremap <F5> :so $MYVIMRC<cr>

" Detect file types
augroup filetypedetect
au BufNewFile,BufRead *.git/COMMIT_EDITMSG setf gitcommit
augroup END

