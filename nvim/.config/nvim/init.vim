set nocompatible

" Now we can turn our filetype functionality back on
filetype plugin indent on

" load external file
source ~/.config/nvim/miscconfigs/fix.vim
source ~/.config/nvim/miscconfigs/plug.vim
source ~/.config/nvim/miscconfigs/keymappings.vim

" python3 host program
let g:pymode_lint_checkers = [ 'pylint' ]
let g:pymode_python = 'python3'
let g:python3_host_prog = '~/anaconda3/bin/python'
let g:python_host_prog = '/usr/bin/python2'
let g:netrw_liststyle = 3


" ctrl-p shit
" let g:ctrlp_by_filename = 0
let g:ctrlp_regexp = 1
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['line', 'dir', 'buffertag', 'tag']



set guicursor=
" Workaround some broken plugins which set guicursor indiscriminately.
autocmd OptionSet guicursor noautocmd set guicursor=

syntax enable

" ----------------------- Color profiles ------------------------------
set background=dark
"colorscheme ingretu
hi Normal ctermbg=none

" ----------------------- Enable/Disable Certain Things -----------------

" indentation
set smartindent
set autoindent
set tabstop=4
set copyindent
set shiftwidth=4
set smarttab
set expandtab

"auto indent
set ai 

"smart indent
set si 

" Show line number
set number

" clipboard
set clipboard+=unnamedplus

" PEP-8 Friendly
au FileType py set textwidth=79
set wrap


" incremental search
" realtime search highlighting as I type
set incsearch

" ignore cases while searching
set ignorecase

" smarter -> useful while searching Upper Cases
" as ignorecase is already enabled
set smartcase

" enable code folding
set foldenable
set foldmethod=indent

" show matching brackets
set showmatch

" show cursor pos
set ruler

" direct allocate to/from system's clipboard
" instead of vim-only
set clipboard=unnamedplus

" highlight current cursor position
set cursorline

" enable spell checking
set spell

" ------------------------------------------------------------------------

" load skeleton codes
autocmd bufnewfile *.py 0r ~/Templates/python.py
autocmd bufnewfile *.cpp 0r ~/Templates/cpp.cpp
autocmd bufnewfile *.c 0r ~/Templates/c.c
autocmd bufnewfile *.html 0r ~/Templates/html.html
autocmd bufnewfile *.sh 0r ~/Templates/bash_script.sh

" Black
autocmd BufWritePre *.py execute ':Black'
