set termguicolors

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
"let g:sonokai_disable_italic_comment = 1

colorscheme sonokai
let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{FugitiveStatusline()}'
      \ },
      \ }
