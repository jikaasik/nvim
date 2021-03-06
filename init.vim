"curl -fLO $HOME/.config/nvim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set nocompatible	
filetype off

call plug#begin('~/.config/nvim/plugged')
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'ncm2/ncm2-bufword'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'
Plug 'eigenfoo/stan-vim'
Plug 'Yggdroot/indentline'
Plug 'vim-test/vim-test'
call plug#end()


" Ale linting
let g:ale_sign_column_always=1
let g:ale_lint_on_save=1
let g:ale_lint_on_text_changed='always'
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]: [%...code...%]'
let g:ale_linters={'python': ['flake8'], 'r': ['lintr']}

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'

let g:airline_powerline_fonts = 1
colorscheme onedark

filetype plugin on
map <silent> <C-n> :NERDTreeFocus<CR>
set number
set relativenumber
set hlsearch
set tabstop=4 softtabstop=4
set noerrorbells
set smartcase
set colorcolumn=80
set clipboard=unnamed
highlight ColorColumn ctermbg=0 guibg=lightgrey
set smartindent
autocmd BufRead,BufNewFile *.htm,*.html setlocal tabstop=2 shiftwidth=2 softtabstop=2

" vim-test bindings
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-a> :TestSuite<CR>
nmap <silent> t<C-f> :TestFile<CR>
let test#python#runner = 'pytest'
let test#python#pytest#options = {'suite': '--verbose'}

source $HOME/.config/nvim/themes/onedark.vim
