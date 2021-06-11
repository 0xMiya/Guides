" auto-install vim-plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
	silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall
endif


call plug#begin('~/.config/nvim/vim-plug/plugged')

"Plug 'morhetz/gruvbox'
Plug 'gruvbox-community/gruvbox'
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
Plug 'preservim/nerdtree'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'mbbill/undotree'
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'
Plug 'drewtempelmeyer/palenight.vim'
"Plug 'nvim-telescope/telescope.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
"Plug 'nvim-lua/diagnostic-nvim'
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'puremourning/vimspector'
"Plug 'neovim/nvim-lsp'
Plug 'joshdick/onedark.vim'
Plug 'sainnhe/sonokai'
Plug 'ayu-theme/ayu-vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

call plug#end() 

" Automatically install missing plugins on startup
"autocmd VimEnter *
"  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \|   PlugInstall --sync | q
"  \| endif
