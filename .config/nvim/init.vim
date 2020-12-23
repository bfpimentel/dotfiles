set nocompatible              " be iMproved, required
filetype off                  " required

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

    Plug 'preservim/nerdtree'                                       " NerdTree
    Plug 'neoclide/coc.nvim', {'branch': 'release'}                 " Code Autocompletion
    Plug 'itchyny/lightline.vim'                                    " Lightline statusbar
    Plug 'tpope/vim-surround'                                       " Change surrounding marks
    Plug 'vim-python/python-syntax'                                 " Python highlighting
    Plug 'ap/vim-css-color'                                         " Color previews for CSS

call plug#end()

autocmd VimEnter * NERDTree | wincmd p

filetype plugin indent on

syntax enable

set path+=**					  " Searches current directory recursively.
set wildmenu					  " Display all matches when tab complete.
set incsearch                     " Incremental search
set hidden                        " Needed to keep multiple buffers open
set nobackup                      " No auto backups
set noswapfile                    " No swap
set t_Co=256                      " Set if term supports 256 colors.
set number relativenumber         " Display line numbers
set clipboard=unnamedplus         " Copy/paste between vim and other programs.
set laststatus=2
set noshowmode
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=4                " One tab == four spaces.
set tabstop=4                   " One tab == four spaces.

let g:rehash256 = 1
let g:lightline = { 'colorscheme': 'darcula' }
let g:python_highlight_all = 1

highlight LineNr           ctermfg=8    ctermbg=none    cterm=none
highlight CursorLineNr     ctermfg=7    ctermbg=8       cterm=none
highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
highlight Statement        ctermfg=2    ctermbg=none    cterm=none
highlight Directory        ctermfg=4    ctermbg=none    cterm=none
highlight StatusLine       ctermfg=7    ctermbg=8       cterm=none
highlight StatusLineNC     ctermfg=7    ctermbg=8       cterm=none
highlight NERDTreeClosable ctermfg=2
highlight NERDTreeOpenable ctermfg=8
highlight Comment          ctermfg=4    ctermbg=none    cterm=italic
highlight Constant         ctermfg=12   ctermbg=none    cterm=none
highlight Special          ctermfg=4    ctermbg=none    cterm=none
highlight Identifier       ctermfg=6    ctermbg=none    cterm=none
highlight PreProc          ctermfg=5    ctermbg=none    cterm=none
highlight String           ctermfg=12   ctermbg=none    cterm=none
highlight Number           ctermfg=1    ctermbg=none    cterm=none
highlight Function         ctermfg=1    ctermbg=none    cterm=none

au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
au BufEnter *.org            call org#SetOrgFileType()

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
