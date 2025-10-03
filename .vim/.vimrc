set nocompatible                   " Use VIM defaults, not VI
set encoding=utf-8                 " Use UTF-8
set cursorline                     " Highlight current line
set termguicolors                  " Our terminal supports 24 bit colors
set background=dark                " We use dark background
set tw=0                           " Do not auto wrap anything
set cc=120                         " Vertical line at column 120 (check Zen function below)
set updatetime=300                 " Having longer updatetime (default is 4000 ms) leads to noticeable delays
set timeout                        " Timeout on mappings and key codes
set timeoutlen=3000                " Timeout on key mappings after 3 seconds
set ttimeoutlen=300                " Timeout on key codes after 100 milliseconds, e.g. after pressing ESC
set signcolumn=yes                 " Always show signcolumn, otherwise it will shift the text when diagnostics appear
set re=0                           " Use new regex engine, required for faster syntax highlight for TypeScript
set backspace=indent,eol,start     " Sane backspace
set hlsearch                       " Highlight search term
set incsearch                      " Show search results as I'm typing (incremental search)
set ignorecase                     " Ignore letter cases when searching
set smartcase                      " Unless there's at least one capital letter or \C, then consider case
set belloff=all                    " Disable bell sounds
set scrolloff=10                   " Number of lines to keep above/below cursor while scrolling
set tabstop=8                      " Show actual tabs as 8 spaces
set softtabstop=4                  " Use 4 spaces when typing <TAB> by default
set shiftwidth=4                   " Default indentation level is 4 columns
set expandtab                      " Insert spaces instead of tabs when indenting
set list                           " Show whitespace
set listchars+=tab:»\              " How to display tabs
set listchars+=trail:·             " How to display trailing spaces
set listchars+=nbsp:␣              " How to display NBSP
set listchars-=eol:$               " Do not display EOL
set guicursor=a:block-nCursor      " Always use block cursor
set noundofile                     " Do not persist undo history
set noswapfile                     " Do not create swap files
set nobackup                       " Do not create backup files
set number                         " Line numbers (check Zen function below)
set relativenumber                 " Relative line numbers (check Zen function below)
set laststatus=2                   " Enable statusline (check Zen function below)
set noshowmode                     " We're using statusline, no need to show mode
set mouse=a                        " Let resize splits with mouse
set formatoptions+=j               " Delete comment character when joining lines

" Set leader to space
let mapleader = ' '

" Do not try to be smart about TypeScript names
let g:typescript_host_keyword = 0

" Detect .h files as C, not C++
let g:c_syntax_for_h = 1

" Show size and last modified date in netrw
let g:netrw_liststyle = 1

" Hide netrw banner
let g:netrw_banner = 0

" Don't put netrw on the alternate buffer
let g:netrw_altfile = 1

" Detect filetypes and apply configs for filetype
filetype plugin on

" Enable syntax highlight
syntax on
colorscheme vim-dark

" Do not select any autocomplete automatically and do not show the preview window
set completeopt=menuone,noselect,popup

" Statusline       N  filename.txt [+]       TXT 12,34 34%
function! MyStatusline()
  let mode_color = ''
  let mode_text = ''
  let current_mode = mode()
  if current_mode ==# 'n'
    let mode_text = 'N'
    let mode_color = 'StatuslineModeNormal'
  elseif current_mode ==# 'i'
    let mode_text = 'I'
    let mode_color = 'StatuslineModeInsert'
  elseif current_mode ==# 'c'
    let mode_text = 'C'
    let mode_color = 'StatuslineModeCommand'
  elseif current_mode ==# 'v' || current_mode ==# 'V' || current_mode ==# "\<c-v>"
    let mode_text = 'V'
    let mode_color = 'StatuslineModeVisual'
  elseif current_mode ==# 'R'
    let mode_text = 'R'
    let mode_color = 'StatuslineModeReplace'
  elseif current_mode ==# 'r'
    let mode_text = 'P'
    let mode_color = 'StatuslineModeOther'
  elseif current_mode ==# '!'
    let mode_text = 'S'
    let mode_color = 'StatuslineModeOther'
  elseif current_mode ==# 't'
    let mode_text = 'T'
    let mode_color = 'StatuslineModeOther'
  else
    let mode_text = 'O'
    let mode_color = 'StatuslineModeOther'
  endif
  return '%#' . mode_color . '# ' . mode_text . ' %#StatuslineFile# %f %m%=%Y %l,%c %p%% '
endfunction
set statusline=%!MyStatusline()

" F2 Toggle Zen mode
function! Zen()
  if &laststatus == 0
    set number relativenumber laststatus=2 cc=120
  else
    set nonumber norelativenumber laststatus=0 cc=0
  endif
endfunction
command! Zen call Zen()
nnoremap <F2> :Zen<cr>

" F3 Build
nnoremap <F3> :make!<cr>

" Remove search highlight on <c-l>
nnoremap <c-l> :nohlsearch<cr><c-l>

" <leader>y/<leader>p for system clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y
vnoremap <leader>Y "+Y
nnoremap <leader>Y "+y$
vnoremap <leader>p "+p
nnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>P "+P

" <S-y> yank until end of line
nnoremap Y y$

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

" Netrw
nnoremap - :Explore<cr>

" Copy current file path to system's clipboard (bc = buffer copy)
nnoremap <leader>bc <cmd>let @+=@%<cr><cmd>echo 'Copied file path: ' . @%<cr>

" F5 reloads vimrc
nnoremap <F5> :so $MYVIMRC<cr>

" Detect file types
augroup filetypedetect
au BufNewFile,BufRead *.git/COMMIT_EDITMSG setf gitcommit
augroup END

" Bultin 'comment' package added in 9.1.0375
if has('patch-9.1.0375')
  packadd! comment
  " Duplicate and comment
  nnoremap yc yy<cmd>normal gcc<cr>p
endif

" F4 will show the highlight group of word under cursor
nnoremap <F4> :echo 'hi<' . synIDattr(synID(line('.'), col('.'), 1), 'name') . '> ' .
            \       'trans<' . synIDattr(synID(line('.'), col('.'), 0),'name') . '> ' .
            \       'lo<' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'<cr>

" Load plugins
call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
call plug#end()

let g:highlightedyank_highlight_duration = 100

" Fuzzy finder -- fzf
nnoremap <leader>sf :Files<cr>
nnoremap <leader>sb :Buffers<cr>
nnoremap <leader>sg :Rg<cr>
nnoremap <leader>sw :Rg <c-r><c-w><cr>

" Jump to line -- Easy Motion
nnoremap <c-j> <plug>(easymotion-j)
nnoremap <c-k> <plug>(easymotion-k)
