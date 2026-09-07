-- lua/plugins/session.lua

return {
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			{ "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
			{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
			{ "<leader>wa", "<cmd>AutoSession toggle<CR>", desc = "Toggle autosave" },
		},
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			auto_restore = false,
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
		config = function(_, opts)
			require("auto-session").setup(opts)
		end,
	},
}
