" <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Better completion ✨experience✨
set completeopt=menuone,noinsert,noselect

" Manually trigger completion
imap <silent> <c-p> <Plug>(completion_trigger)
