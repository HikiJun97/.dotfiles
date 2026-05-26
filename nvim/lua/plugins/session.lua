-- lua/plugins/session.lua

return {
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
			{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
			{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
		},
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
		config = function()
			require("auto-session").setup()
		end,
	},
}
