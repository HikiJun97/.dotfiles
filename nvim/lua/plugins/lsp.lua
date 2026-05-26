-- lua/plugins/lsp.lua

return {
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"docker_compose_language_service",
				"dockerls",
				"html",
				"pyright",
				"tailwindcss",
				"cssls",
				-- "ts_ls",
				"vtsls",
				"vue_ls",
				"lua_ls",
				"jsonls",
				"gopls",
				"eslint",
				-- "biome",
				-- "prettier",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
}
