" --------------------- key mapping ---------------------------------

" mapping kj
:imap kj <Esc>
:imap KJ <Esc>
:imap kJ <Esc>
:imap Kj <Esc>

" space is used to toggle the search terms that are highlighted
:noremap <Space> :set hlsearch! hlsearch?<CR>
:noremap <C-Space> :set spell! spell?<CR>

" tab navigation made easy
:noremap <S-h> gT
:noremap <S-l> gt
:noremap t0 :tabfirst<cr>
:noremap tt :tablast<cr>

"map ek to open explore mode
"let mapleader=" "
:noremap ek :E<cr>

:noremap en :NERDTreeToggle<cr>

" map navigation over spllited windows
"map <C-J> <C-W>j<C-W>_
"map <C-K> <C-W>k<C-W>_
"nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

:vnoremap i g<C-g>

" navigate to % portion of page using gX 
:noremap g0 gg
:noremap g1 10%
:noremap g2 20%
:noremap g3 30%
:noremap g4 40%
:noremap g5 50%
:noremap g6 60%
:noremap g7 70%
:noremap g8 80%
:noremap g9 90%
