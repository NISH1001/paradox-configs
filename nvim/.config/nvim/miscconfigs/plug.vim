" Autoinstall vim-plug {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}

" -------- Plugin using Plug ----------------------------------

""" plugin manager vim-plug """
call plug#begin("~/.config/nvim/plugged")

" deoplete
"Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
"Plug 'Shougo/deoplete.nvim'

Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" latex
" Plug 'lervag/vimtex'

" ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" airline 
Plug 'vim-airline/vim-airline'

"nerd comment
Plug 'scrooloose/nerdcommenter'

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" nerdtree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" syntastic
" Plug 'vim-syntastic/syntastic'
"Plug 'scrooloose/syntastic'

" neomake
Plug 'neomake/neomake'

" python mode
" Plug 'python-mode/python-mode'
Plug 'python-mode/python-mode', {'branch': 'develop'}

" startify
Plug 'mhinz/vim-startify'

" vim sugar for UNIX shell commands
Plug 'tpope/vim-eunuch'

" Display indent lines
Plug 'Yggdroot/indentLine'

" Icon for filetype
Plug 'ryanoasis/vim-devicons'

" Commenting made easy
Plug 'tpope/vim-commentary'

Plug 'SirVer/ultisnips'

" custom plugin

Plug '~/.config/nvim/plugged/join-lines'

call plug#end()

" ---------------- plugin configurations ------------

" NERDTree configuration
" autocmd VimEnter * NERDTree | wincmd p


" deoplete config
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>
autocmd CompleteDone * pclose " To close preview window of deoplete automagically
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
  autocmd FileType python setlocal omnifunc=tern#Complete
endif

" neomake
autocmd! BufWritePost * Neomake

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
