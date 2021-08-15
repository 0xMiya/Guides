if (has('termguicolors'))
	set termguicolors
endif

colorscheme PaperColor
"let g:lightline = { 'colorscheme': 'PaperColor dark' }
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'fugitive' ] ]
      \ },
      \ 'component': {
      \   'fugitive': '%{FugitiveStatusline()}'
      \ },
      \ }
