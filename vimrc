" Set VIM localization to English
language en_US.utf8

" Force bash
set shell=bash

" Add ~/.vim to runtime path (rtp)
set rtp+=~/.vim

call plug#begin('~/.vim/plugged')
    " Colorscheme
    Plug 'tek256/simple-dark'
    " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " LSP
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    " Highlight Yanked text
    Plug 'machakann/vim-highlightedyank'
    " File browser
    Plug 'tpope/vim-vinegar'
call plug#end()

" Colorscheme
set termguicolors
set background=dark
colorscheme simple-dark

" Sane backspace
set nocompatible
set backspace=indent,eol,start

" Highlight search term
set hlsearch
nnoremap <esc><esc> :nohlsearch<cr>

" Highlight yanked tex
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

" Set leader as <SPACE>
let mapleader = ' '

" FZF
nnoremap <leader>ff :FZF<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fg :Rg<cr>
let g:fzf_vim = {}
let g:fzf_vim.preview_bash = '/c/Program Files/Git/git-bash.exe'
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
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
