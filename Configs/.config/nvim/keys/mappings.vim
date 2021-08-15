" <remap> <new> <old>

" Dvorak it!
no d h
no h j
no t k
no n l
"no s :
"no S :
nmap <Esc> :
no j d
" zz it centered
no l nzzzv
no L Nzzzv
no - $
no _ ^
no H 12<Down>
no T 12<Up>

" Rebind what was lost from d,h,t and n
no k t

" Change selected pane (splits)
nnoremap <C-H> <C-W><C-J>
nnoremap <C-T> <C-W><C-K>
nnoremap <C-N> <C-W><C-L>
nnoremap <C-D> <C-W><C-H>
" Select next pane
"no N <C-w><C-w>

" Turn off highlighting after search
map <leader>nh :noh<CR>

" -- Prime told me to --

" Keeps the cursor in the same position
nnoremap J mzJ`z

" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u

" Jumplist mutations
"nnoremap <expr> t (v:count > 5 ? "m'" . v:count : "") . 't'
"nnoremap <expr> h (v:count > 5 ? "m'" . v:count : "") . 'h'

" Moving text
nnoremap <leader>h :m .+1<CR>==
nnoremap <leader>t :m .-2<CR>==
inoremap <C-h> <esc>:m .+1<CR>==a
inoremap <C-t> <esc>:m .-2<CR>==a
vnoremap H :m '>+1<CR>gv=gv
vnoremap T :m '<-2<CR>gv=gv

" leave terminal mode
tnoremap <Esc> <C-\><C-n>
