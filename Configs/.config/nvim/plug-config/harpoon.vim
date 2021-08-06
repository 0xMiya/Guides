lua << EOF
require("harpoon").setup({
	global_settings = {
		save_on_toggle = true,
	},
})
EOF

nnoremap <leader>m <cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>a <cmd>lua require("harpoon.mark").add_file()<CR>
