" ============================================================================
" Plugin post-load configuration
" ============================================================================
" NOTE: Plugin installation is handled by lazy.nvim in lua/plugins.lua.
" This file used to drive vim-plug; it now only holds plugin-specific
" vimscript configuration that runs after plugins are on the runtimepath.
"
" Kept filename for back-compat (init.vim.bak still sources it).
" ============================================================================

" NERDTree
" autocmd VimEnter * NERDTree | wincmd p

" omnifuncs (fallbacks for filetypes without an LSP attached)
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" neomake: keep for non-Python filetypes; Python diagnostics come from
" ruff LSP + basedpyright now, not neomake.
autocmd! BufWritePost * Neomake

" UltiSnips triggers
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Dashboard
source ~/.config/nvim/miscconfigs/dashboard.vim

" nvim-tree
source ~/.config/nvim/miscconfigs/nvim-tree.vim
