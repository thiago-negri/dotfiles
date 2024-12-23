set nocompatible
set encoding=utf-8

" Add folders to runtime path (rtp)
set rtp+=~/.vim
set rtp+=~/.fzf

" Plugins
call plug#begin('~/.vim/plugged')
    Plug 'tek256/simple-dark' " Colorscheme
    Plug 'thiago-negri/fzf.vim' " Fuzzy finder
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " COC (LSP)
    Plug 'machakann/vim-highlightedyank' " Quick highlight yanked text
    Plug 'tpope/vim-vinegar' " File browser
    Plug 'tpope/vim-commentary' " Comment commands
    Plug 'easymotion/vim-easymotion' " <leader>j and <leader>k
    Plug 'tpope/vim-sleuth' " Auto detect tabstop
call plug#end()

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved
set signcolumn=yes

" Use new regular expression engine, required for faster syntax highlight for TypeScript
set re=0

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
set scrolloff=15

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
nmap <silent> [g <plug>(coc-diagnostic-prev)
nmap <silent> ]g <plug>(coc-diagnostic-next)
nmap <silent> <leader>q :CocDiagnostics<cr>
nmap <silent> gd <plug>(coc-definition)
nmap <silent> gy <plug>(coc-type-definition)
nmap <silent> gi <plug>(coc-implementation)
nmap <silent> gr <plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<cr>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nmap <leader>rn <plug>(coc-rename)
xmap <leader>f <plug>(coc-format-selected)
nmap <leader>f <plug>(coc-format-selected)
nmap <leader>ca <plug>(coc-codeaction-cursor)

" Navigation
nnoremap <c-u> <c-u>zz
nnoremap <c-d> <c-d>zz
nnoremap G Gzz

" Duplicate and comment
nnoremap yc yy<cmd>normal gcc<cr>p

" Easy Motion
map <leader>j <plug>(easymotion-j)
map <leader>k <plug>(easymotion-k)

