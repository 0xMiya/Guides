" auto-install vim-plug
if empty(glob('~/.config/nvim/vim-plug/plug.vim'))
  silent !curl -fLo ~/.config/nvim/vim-plug/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/vim-plug/plugged')

"Plug 'morhetz/gruvbox'
Plug 'gruvbox-community/gruvbox'
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mbbill/undotree'
"Plug 'nvim-telescope/telescope.nvim'
"Plug 'neovim/nvim-lspconfig'
"Plug 'nvim-lua/completion-nvim'
"Plug 'nvim-lua/diagnostic-nvim'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'puremourning/vimspector'

call plug#end() 

" Automatically install missing plugins on startup
"autocmd VimEnter *
"  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \|   PlugInstall --sync | q
"  \| endif
