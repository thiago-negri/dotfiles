" language is set by install.sh

" vim plz
set nocompatible

" Add ~/.vim to runtime path (rtp)
set rtp+=~/.vim
set rtp+=~/.fzf

call plug#begin('~/.vim/plugged')
    " Colorscheme
    Plug 'tek256/simple-dark'
    " FZF
    Plug 'thiago-negri/fzf.vim'
    " LSP
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    " Highlight Yanked text
    Plug 'machakann/vim-highlightedyank'
    " File browser
    Plug 'tpope/vim-vinegar'
    " Comment commands
    Plug 'tpope/vim-commentary'
    " Easy Motion
    Plug 'easymotion/vim-easymotion'
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

" LSP
if executable('zls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'zls',
        \ 'cmd': {server_info->['zls']},
        \ 'allowlist': ['zig'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go,*.zig call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Navigation
nnoremap <c-u> <c-u>zz
nnoremap <c-d> <c-d>zz
nnoremap G Gzz

" Duplicate and comment
nnoremap yc yy<cmd>normal gcc<cr>p

" Easy Motion
map <leader>j <plug>(easymotion-j)
map <leader>k <plug>(easymotion-k)

