let NERDTreeMapOpenInTab='v'
let NERDTreeMenuDown='h'
let NERDTreeMenuUp='t'
 
let NERDTreeMapUpdir='d'
let NERDTreeMapChangeRoot='n' 

nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


" -- NERDTree general --
"
"  Ctrl-t       Toggle NERDTree window
"  Ctrl-f       Show file in window
"  leader (,)-n Focus NERDTree
"
" -- Inside of NERDTree --
"
"  Enter        Open file (replaces previous file)
"  s            Open file in vertical split
"  i            Open file in horizontal split
"  o            Open in previous window
"  go           Open in preview (don't focus the opened file)
"  v            Open in new tab
"  T            Open in new tab without switching to it
"
" -- On a node (directory) --
"
"  o, Enter     Expand directory
"  O            Expand diretory and subdirectories recursively
"  v, T         Open dir in new tab, silently
"  x, X         Close dir, recursively
"  e            Explore dir (look at it in a new panel)
"
" -- Filesystem --
"
"  n            Change root to selected directory
"  d            Move tree root up a dir
"  U            Move tree root up but leave old root open (expanded)
"  r            Refresh dir under cursor
"  R            Refresh root dir
"  A            Zoom (maximize-minimize NERDTree window)
"  m            Show menu
"  I            Toggle hidden files
"  B            Toggle bookmarks
"
" -- Tree navigation --
"
"  P            go to root
"  p            go to parent
"  K            go to first child
"  J            go to last child
"  Ctrl-j, -k   go to next, previous sibling (file in directory)
"
" -- Bookmarks --
"
"  :Bookmark    Bookmark directory under cursor
"  D            Remove bookmark under cursor
"  B            Toggle bookmarks
