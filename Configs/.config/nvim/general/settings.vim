syntax enable 								" Enables syntax highlighting
set nowrap 									" Display long lines as just one line
set whichwrap+=<,>,[,],h,l
set ruler									" Show the cursor position at all time
set cmdheight=2								" More space for displaying messages
set t_Co=256								" Support 256 colors
set conceallevel=0							" Show `` in markdown files
set tabstop=4 softtabstop=4					" Insert 4 spaces for a tab
set shiftwidth=4
set expandtab
set smartindent								" Makes indenting smart
"set softtabstop=0 noexpandtab
set background=dark							" Make background dark
"set number									" Show line numbers
set relativenumber							" Make line numbers relative
set nu                                      " Also show the current line number
set autoindent								" Good auto indent
set laststatus=2							" Always display the status line
set cursorline								" Highlight the current line
set showtabline=2							" Always show tabs
set nobackup								" Recommended by coc
set nowritebackup
set signcolumn=yes							" Always show sign column
set updatetime=300							" Faster completion
set timeoutlen=100							" By default 1000 ms
set clipboard=unnamedplus					" Copy paste between vim and everything else
set colorcolumn=80 							" Display vertical line after 80 columns
"set nohlsearch                              " Do not continue highlightning after search
set exrc 									" Type vim . in a directory and it will load the vimrc inside the same directory
"set hidden                                  " Keep files open in an extra buffer
set noerrorbells                            " Keep quiet!
set incsearch                               " Highlight while searching
set scrolloff=8                             " Start scrolling when 8 lines from the top/bottom away
set sidescrolloff=8                         " Start scrolling horizontaly when 8 characters from left/right away
set completeopt=menuone,noinsert,noselect   " Autocomplete options
set signcolumn=yes                          " Add extra column for linting, etc...

set noshowmode

"set swapfile
set undodir=~/.vim/undodir                  " Set the directory for backup files
set undofile

" Display whitespace characters
set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:< "⎆·
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣ "⎆
"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

"set syntax=whitespace
