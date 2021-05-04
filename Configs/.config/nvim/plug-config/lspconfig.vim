let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

lua << EOF
require'lspconfig'.gopls.setup{ on_attach=require'completion'.on_attach }
require'lspconfig'.rust_analyzer.setup{}
EOF
