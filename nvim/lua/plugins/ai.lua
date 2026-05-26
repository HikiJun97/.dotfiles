-- lua/plugins/ai.lua

return {
	{
		"greggh/claude-code.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("claude-code").setup()
		end,
	},
	{
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false,
		---@module 'avante'
		---@type avante.Config
		opts = {
			provider = "claude",
			providers = {
				claude = {
					auth_type = "api",
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-5",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
				moonshot = {
					endpoint = "https://api.moonshot.ai/v1",
					model = "kimi-k2-0711-preview",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 32768,
					},
				},
				openai = {
					endpoint = "https://api.openai.com/v1",
					model = "gpt-5.4",
					timeout = 30000,
				},
			},
			behaviour = {
				enable_fastapply = true,
			},
			acp_providers = {
				["claude-code"] = {
					command = "npx",
					args = { "@agentclientprotocol/claude-agent-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						ANTHROPIC_API_KEY = os.getenv("AVANTE_ANTHROPIC_API_KEY"),
					},
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"ibhagwan/fzf-lua",
			"stevearc/dressing.nvim",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = { insert_mode = true },
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
	},
}
