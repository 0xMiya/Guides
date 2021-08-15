if (has('termguicolors'))
	set termguicolors
endif

colorscheme badwolf
"highlight Normal guibg=none                 
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
