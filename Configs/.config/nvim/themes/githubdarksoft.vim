set termguicolors

let g:gh_color = "soft"

colorscheme ghdark
let g:lightline = {
      \ 'colorscheme': 'ghdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{FugitiveStatusline()}'
      \ },
      \ }
