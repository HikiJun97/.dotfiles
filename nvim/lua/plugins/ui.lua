-- lua/plugins/ui.lua

return {
	"ctrlpvim/ctrlp.vim",
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
		lazy = false,
	},
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" },
		config = function() end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline!<CR>", desc = "Toggle outline w/o focus" },
			{ "<F3>", "<cmd>Outline!<CR>", desc = "Toggle outline w/o focus" },
		},
		opts = {},
		config = function()
			require("outline").setup({
				outline_window = {
					width = 40,
					relative_width = false,
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = { default_file_explorer = true },
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			window = {
				position = "left",
				width = 33,
				mappings = {
					["<bs>"] = false,
					["-"] = "navigate_up",
				},
			},
			filesystem = {
				window = {
					fuzzy_finder_mappings = {
						["<C-k>"] = "move_cursor_up",
						["<C-j>"] = "move_cursor_down",
					},
				},
				hijack_netrw_behavior = "disabled",
			},
		},
		keys = {
			{ "<F2>", ":Neotree toggle<CR>", { noremap = true } },
		},
		config = function()
			local function on_rename(old_path, new_path)
				local clients = vim.lsp.get_clients()
				for _, client in ipairs(clients) do
					if client.supports_method("workspace/willRenameFiles") then
						local resp = client.request_sync("workspace/willRenameFiles", {
							files = {
								{
									oldUri = vim.uri_from_fname(old_path),
									newUri = vim.uri_from_fname(new_path),
								},
							},
						}, 1000)
						if resp and resp.result then
							vim.lsp.util.apply_workspace_edit(resp.result, "utf-8")
						end
					end
				end
			end

			require("neo-tree").setup({
				event_handlers = {
					{
						event = "file_moved",
						handler = function(args)
							on_rename(args.source, args.destination)
						end,
					},
					{
						event = "file_renamed",
						handler = function(args)
							on_rename(args.source, args.destination)
						end,
					},
				},
				system = {
					commands = {
						avante_add_files = function(state)
							local node = state.tree:get_node()
							local filepath = node:get_id()
							local relative_path = require("avante.utils").relative_path(filepath)
							local sidebar = require("avante").get()
							local open = sidebar:is_open()
							if not open then
								require("avante.api").ask()
								sidebar = require("avante").get()
							end
							sidebar.file_selector:add_selected_file(relative_path)
							if not open then
								sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
							end
						end,
					},
					window = {
						mappings = {
							["oa"] = "avante_add_files",
						},
					},
				},
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
