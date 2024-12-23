" language is set by install.sh

" vim plz
set nocompatible
set encoding=utf-8

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use new regular expression engine, required for faster syntax highlight
" for TypeScript
set re=0

" Add folders to runtime path (rtp)
set rtp+=~/.vim
set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
    " Colorscheme
    Plug 'tek256/simple-dark'
    " FZF
    Plug 'thiago-negri/fzf.vim'
    " COC (LSP)
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Highlight Yanked text
    Plug 'machakann/vim-highlightedyank'
    " File browser
    Plug 'tpope/vim-vinegar'
    " Comment commands
    Plug 'tpope/vim-commentary'
    " Easy Motion
    Plug 'easymotion/vim-easymotion'
    " Auto detect tabstop
    Plug 'tpope/vim-sleuth'
call plug#end()

" Colorscheme
set termguicolors
set background=dark
colorscheme simple-dark

" Sane backspace
set backspace=indent,eol,start

" Highlight search term
set hlsearch
nnoremap <c-l> :nohlsearch<cr><c-l>

" Highlight yanked tex
let g:highlightedyank_highlight_duration = 100

" Disable bell sounds
set belloff=all

" Number of lines to keep above/below cursor while scrolling
set scrolloff=10

" Show actual tabs as 8 spaces
set tabstop=8

" Use 4 spaces when typing <TAB>
set softtabstop=4
set shiftwidth=4
set expandtab

" No temporary files
set noundofile
set noswapfile
set nobackup

" Show whitespace
set list
set listchars+="tab:» "
set listchars+=trail:·
set listchars+=nbsp:␣
set listchars-=eol:$

" Always use block cursor
set guicursor=a:block-nCursor

" Set leader as space
let mapleader = ' '

" FZF
nnoremap <silent> <leader>ff :FZF<cr>
nnoremap <silent> <leader>fb :Buffers<cr>
nnoremap <silent> <leader>fg :Rg<cr>
let g:fzf_vim = {}
let g:fzf_vim.preview_bash = 'bash'
let g:fzf_preview_window = []
let g:fzf_layout = { 'down' : '35%' }

" COC
inoremap <silent><expr> <c-n> coc#pum#visible() ? coc#pum#next(1) : coc#refresh()
inoremap <expr><c-p> coc#pum#visible() ? coc#pum#prev(1) : "\<c-p>"
inoremap <silent><expr> <c-y> coc#pum#visible() ? coc#pum#confirm() : "\<c-y>"
inoremap <silent><expr> <c-@> coc#refresh()
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> <leader>q :CocDiagnostics<cr>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
nmap <leader>ca <Plug>(coc-codeaction-cursor)

" Navigation
nnoremap <c-u> <c-u>zz
nnoremap <c-d> <c-d>zz
nnoremap G Gzz

" Duplicate and comment
nnoremap yc yy<cmd>normal gcc<cr>p

" Easy Motion
map <leader>j <plug>(easymotion-j)
map <leader>k <plug>(easymotion-k)

