set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
"let g:tokyonight_transparent_background = 1

colorscheme tokyonight
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{FugitiveStatusline()}'
      \ },
      \ }
