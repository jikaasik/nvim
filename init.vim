"curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set nocompatible	" be iMproved, required
filetype off

call plug#begin('~/.config/nvim/plugged')
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


call plug#end()


map <silent> <C-n> :NERDTreeFocus<CR>
set number
set relativenumber
set hlsearch
set tabstop=4 softtabstop=4
set noerrorbells
set smartcase
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
set smartindent

