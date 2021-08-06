" auto-install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.config/nvim/vim-plug/plugged')

" -- Syntax highlighting --
Plug 'sheerun/vim-polyglot'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " :TSInstall <language>
" -- Colorschemes --
Plug 'gruvbox-community/gruvbox'
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ghifarit53/tokyonight-vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'wojciechkepka/vim-github-dark'
Plug 'projekt0n/github-nvim-theme'
Plug 'joshdick/onedark.vim'
Plug 'sainnhe/sonokai'
Plug 'ayu-theme/ayu-vim'
Plug 'bluz71/vim-moonfly-colors'
"Plug 'morhetz/gruvbox'
" -- Statusline/Tabline --
Plug 'itchyny/lightline.vim'
" -- IDE --
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
"Plug 'puremourning/vimspector'
" -- Other --
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'nvim-lua/popup.nvim' " dependency for telescope, harpoon
Plug 'nvim-lua/plenary.nvim' " dependency for telescope, harpoon

" -- Language specific --
"Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

call plug#end() 

" Automatically install missing plugins on startup
"autocmd VimEnter *
"  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \|   PlugInstall --sync | q
"  \| endif
