" VUNDLE START
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Solarized colors
Plugin 'altercation/vim-colors-solarized'

" CtrlP - Fuzzy file finder -- active with <C-p>
Plugin 'ctrlpvim/ctrlp.vim'

" Vim Rails
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-bundler'

" Rename files
Plugin 'Rename2'

" NERDTree -- show file tree, <C-n> to activate
Plugin 'nerdtree'

" Snipmate -- active on tab on insert mode, e.g. `def<tab>` to create a new
" Ruby method
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" Vim airline -- beautiful status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" emmet.io -- html expansion, activated by `<c-y>,`
Plugin 'mattn/emmet-vim'

" Syntastic -- show syntax errors on save
Plugin 'scrooloose/syntastic'

" surround.vim -- work with surroundings, use 's' for surroundings, e.g.
" `cs"'` to change surrounding double quotes to single quotes; `ysiw[` to put
" square brackets surrounding a word
Plugin 'tpope/vim-surround'

" easymotion -- press \\<motion> to highligh alternatives, e.g. \\s (for
" searching a single char)
Plugin 'easymotion/vim-easymotion'

" endwise.vim -- auto add ending keyword to common structures, e.g. auto add
" 'end' after 'def' or 'if' in Ruby
Plugin 'tpope/vim-endwise'

" auto delimit quotes
Plugin 'raimondi/delimitmate'

call vundle#end()
filetype plugin indent on
" VUNDLE END

" Activate solarized dark theme
syntax enable
set background=dark
colorscheme solarized

" Relative line numbers + current line number
set relativenumber
set number

" Relative line numbers makes VIM a bit slow
" the following help it to be faster
set ttyfast
set lazyredraw

" Ctrl-S to save the file
inoremap <C-s> <esc>:w<cr>
nnoremap <C-s> :w<cr>

" Ctrl-V to paste content from clipboard
" inoremap <C-v> <esc>:set paste<cr>i<C-r>*<esc>:set nopaste<cr>i

" Auto indent
set smartindent
set autoindent
filetype indent on

" Do not use tabs
set expandtab
set softtabstop=2
set shiftwidth=2

" Rails autocomplete
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

" Backspace
set bs=2

" Show line and column number at bottom right corner
set ruler

" Ctrl-N to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Ctrl-V to paste in insert mode
imap <C-v> <esc>:set paste<cr>"+p<esc>:set nopaste<cr>a

" Ctrl-C do copy to system clipboard in visual mode
vnoremap <C-c> "+y

" Always show VIM Airline
set laststatus=2

