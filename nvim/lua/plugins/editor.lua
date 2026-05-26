-- lua/plugins/editor.lua

return {
	"tpope/vim-surround",
	"alvan/vim-closetag",
	"anscoral/winmanager.vim",
	"shime/vim-livedown",
	"tpope/vim-sensible",
	"junegunn/goyo.vim",
	"Raimondi/delimitMate",
	"blueyed/vim-diminactive",
	"uiiaoo/java-syntax.vim",
	"norcalli/nvim-colorizer.lua",
	{ "echasnovski/mini.ai", version = false },
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		enabled = 1,
	},
	{
		"karb94/neoscroll.nvim",
		opts = {},
	},
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = 100,
				default_mappings = true,
				mappings = {
					i = { j = { k = "<Esc>", j = false } },
					c = { j = { k = "<C-c>", j = false } },
					t = { j = { k = "<C-\\><C-n>" } },
					v = { j = { k = "<Esc>" }, k = { k = false } },
					s = { j = { k = "<Esc>" } },
					n = {},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			local js_formatters = function(bufnr)
				if vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) then
					return { "biome" }
				end
				return { "prettierd", "prettier", stop_after_first = true }
			end
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
					javascript = js_formatters,
					javascriptreact = js_formatters,
					typescript = js_formatters,
					typescriptreact = js_formatters,
					vue = js_formatters,
					json = { "prettier", stop_after_first = true },
					go = { "goimports", "gofmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		"nathanaelkane/vim-indent-guides",
		config = function()
			vim.g.indent_guides_enable_on_vim_startup = 1
			vim.g.indent_guides_start_level = 2
			vim.g.indent_guides_guide_size = 1
		end,
	},
}
