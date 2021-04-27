let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

lua << EOF
require'lspconfig'.gopls.setup{}
require'lspconfig'.rust_analyzer.setup{}
EOF
