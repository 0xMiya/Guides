set termguicolors     " enable true colors support

let g:moonflyCursorColor = 1
let g:moonflyUnderlineMatchParen = 1

colorscheme moonfly
let g:lightline = {
      \ 'colorscheme': 'moonfly',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{FugitiveStatusline()}'
      \ },
      \ }
