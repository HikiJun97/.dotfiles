vim.cmd([[
    highlight Normal guibg=none
    highlight NonText guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
]])

if vim.g.vscode then
	print("Running in VSCode-neovim")
	-- local vscode = require("vscode")
	vim.g.clipboard = vim.g.vscode_clipboard
	-- Go to references
	vim.keymap.set("n", "grr", function()
		require("vscode-neovim").call("editor.action.referenceSearch.trigger")
	end, { silent = true })

	-- Go to definition
	vim.keymap.set("n", "gd", function()
		require("vscode-neovim").call("editor.action.revealDefinition")
	end, { silent = true })

	-- Open definition aside
	vim.keymap.set("n", "gD", function()
		require("vscode-neovim").call("editor.action.revealDefinitionAside")
	end, { silent = true })

	-- Go back
	vim.keymap.set("n", "gb", function()
		require("vscode-neovim").call("workbench.action.navigateBack")
	end, { silent = true })

	-- Next error/warning
	vim.keymap.set("n", "ge", function()
		require("vscode-neovim").call("editor.action.marker.next")
	end, { silent = true })

	-- Previous error/warning
	vim.keymap.set("n", "gE", function()
		require("vscode-neovim").call("editor.action.marker.prev")
	end, { silent = true })

	-- Show hover
	vim.keymap.set("n", "gh", function()
		require("vscode-neovim").call("editor.action.showHover")
	end, { silent = true })
else
	print("Running in Neovim")
	-- vim.o.clipboard = "unnamedplus"
	vim.g.clipboard = "osc52"

	-- vim.g.clipboard = {
	--     name = "OSC 52",
	--     copy = {
	--         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
	--         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	--     },
	--     paste = {
	--         ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
	--         ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	--     },
	-- }

	-- 필수 설정들만 남김
	vim.opt.background = "dark"
	vim.opt.number = true
	vim.opt.autowrite = true
	vim.opt.smartcase = true
	vim.opt.scrolloff = 2
	vim.opt.laststatus = 3

	-- 들여쓰기 관련 (핵심만)
	vim.opt.shiftwidth = 4
	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.expandtab = true
	vim.opt.smartindent = true
	vim.opt.backup = false
	vim.opt.writebackup = false
	vim.opt.updatetime = 500
	vim.opt.signcolumn = "yes"
	vim.opt.fileencodings = "utf-8,euc-kr"

	-- 유용한 단축키와 명령어
	vim.cmd([[abbr funciton function]])

	-- 파일 자동 새로고침
	vim.cmd([[
  set autoread
  au CursorHold,CursorHoldI * silent! checktime
]])

	-- Bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			lazyrepo,
			lazypath,
		})
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)

	-- Make sure to setup `mapleader` and `maplocalleader` before
	-- loading lazy.nvim so that mappings are correct.
	-- This is also a good place to setup other settings (vim.opt)
	vim.g.mapleader = "\\"
	vim.g.maplocalleader = "\\"

	-- uv tool install --upgrade pynvim
	vim.g.python3_host_prog = vim.fn.expand("~/.local/bin/pynvim-python")

	local languages = {
		"bash",
		"c",
		"cmake",
		"comment",
		"cpp",
		"css",
		"csv",
		"dockerfile",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"graphql",
		"helm",
		"html",
		"http",
		"java",
		"javascript",
		"jq",
		"json",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"mermaid",
		"nginx",
		"objdump",
		"powershell",
		"python",
		"regex",
		"requirements",
		"scss",
		"sql",
		"ssh_config",
		"svelte",
		"swift",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"xml",
		"yaml",
	}

	-- Lazy.nvim configuration
	require("lazy").setup({
		{
			"greggh/claude-code.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim", -- Required for git operations
			},
			config = function()
				require("claude-code").setup()
			end,
		},
		"SirVer/ultisnips",
		"honza/vim-snippets", -- Collection of snippets for various programming languages
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"quangnguyen30192/cmp-nvim-ultisnips",
		"onsails/lspkind.nvim",
		"uiiaoo/java-syntax.vim", -- Improved Java syntax highlighting
		"tpope/vim-surround", -- Quoting/parenthesizing made simple
		"alvan/vim-closetag", -- Auto close (X)HTML tags
		"anscoral/winmanager.vim", -- Enhances window management capabilities
		"shime/vim-livedown", -- Markdown preview functionality
		"tpope/vim-sensible", -- Sensible default settings for Vim
		"junegunn/goyo.vim", -- Distraction-free writing mode
		"Raimondi/delimitMate", -- Auto-completion for quotes, parens, brackets, etc.
		"blueyed/vim-diminactive", -- Dim inactive windows
		"ctrlpvim/ctrlp.vim", -- Full path fuzzy file, buffer, tag, etc. finder
		"norcalli/nvim-colorizer.lua",
		{ "echasnovski/mini.ai", version = false },
		{
			"NeogitOrg/neogit",
			lazy = true,
			dependencies = {
				-- Only one of these is needed.
				"sindrets/diffview.nvim", -- optional
				"esmuellert/codediff.nvim", -- optional

				-- For a custom log pager
				"m00qek/baleia.nvim", -- optional

				-- Only one of these is needed.
				"nvim-telescope/telescope.nvim", -- optional
				"ibhagwan/fzf-lua", -- optional
				"nvim-mini/mini.pick", -- optional
				"folke/snacks.nvim", -- optional
			},
			cmd = "Neogit",
			keys = {
				{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
			},
		},
		{
			"hrsh7th/nvim-cmp",
			config = function()
				-- Autocompletion setup
				local cmp = require("cmp")
				cmp.setup({
					sources = {
						{ name = "ultisnips" },
						{ name = "nvim_lsp" },
						{ name = "path" },
						{ name = "buffer" },
					},
					snippet = {
						expand = function(args)
							-- You need Neovim v0.10 to use vim.snippet
							vim.snippet.expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-e>"] = cmp.mapping.close(),
						-- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
						-- ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						["<Down>"] = cmp.mapping.select_next_item({
							behavior = cmp.SelectBehavior.Insert,
						}),
						["<Up>"] = cmp.mapping.select_prev_item({
							behavior = cmp.SelectBehavior.Insert,
						}),
					}),
					formatting = {
						format = require("lspkind").cmp_format({
							mode = "symbol",
							maxwidth = 50,
							ellipsis_char = "...",
							show_labelDetails = true,
						}),
					},
				})
			end,
		},
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
					-- "debugpy",
					-- "flake8"
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
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").install({ "all" })
				vim.api.nvim_create_autocmd("FileType", {
					pattern = languages,
					callback = function()
						pcall(vim.treesitter.start)
						-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end,
				})
			end,
		},
		{
			"max397574/better-escape.nvim",
			config = function()
				require("better_escape").setup({
					timeout = 100, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
					default_mappings = true, -- setting this to false removes all the default mappings
					mappings = {
						-- i for insert
						i = {
							j = {
								-- These can all also be functions
								k = "<Esc>",
								j = false,
							},
						},
						c = {
							j = {
								k = "<C-c>",
								j = false,
							},
						},
						t = {
							j = {
								k = "<C-\\><C-n>",
							},
						},
						v = {
							j = {
								k = "<Esc>",
							},
							k = {
								k = false,
							},
						},
						s = {
							j = {
								k = "<Esc>",
							},
						},
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
			"lewis6991/gitsigns.nvim",
		},
		{
			"sindrets/diffview.nvim",
		},
		{
			"folke/ts-comments.nvim",
			event = "VeryLazy",
			-- enabled = vim.fn.has("nvim-0.10.1") == 1,
			enabled = 1,
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			keys = {
				-- Will use Telescope if installed or a vim.ui.select picker otherwise
				{ "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
				{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
				{ "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
			},

			---enables autocomplete for opts
			---@module "auto-session"
			---@type AutoSession.Config
			opts = {
				suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				-- log_level = 'debug',
			},
			config = function()
				require("auto-session").setup()
				vim.api.nvim_create_user_command("SS", ":SessionSave", {})
			end,
		},
		{
			"karb94/neoscroll.nvim",
			opts = {},
		},
		{
			"nvim-telescope/telescope.nvim",
			keys = function()
				local builtin = require("telescope.builtin")
				return {
					{ "<leader>ff", builtin.find_files, desc = "Find files" },
					{ "<leader>fg", builtin.live_grep, desc = "Live grep" },
					{ "<leader>fb", builtin.buffers, desc = "Find buffers" },
					{ "<leader>fh", builtin.help_tags, desc = "Help tags" },
				}
			end,
		},
		{
			"nvim-telescope/telescope-file-browser.nvim",
			opts = {
				extensions = {
					file_browser = {
						theme = "ivy",
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = false,
					},
				},
			},
			dependencies = {
				"nvim-telescope/telescope.nvim",
				"nvim-lua/plenary.nvim",
			},
			config = function() end,
		},
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"yetone/avante.nvim",
			-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
			-- ⚠️ must add this setting! ! !
			build = vim.fn.has("win32") ~= 0
					and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
				or "make",
			event = "VeryLazy",
			version = false, -- Never set this value to "*"! Never!
			---@module 'avante'
			---@type avante.Config
			opts = {
				-- add any opts here
				-- for example
				provider = "claude",
				providers = {
					claude = {
						auth_type = "api",
						endpoint = "https://api.anthropic.com",
						model = "claude-sonnet-4-5",
						timeout = 30000, -- Timeout in milliseconds
						extra_request_body = {
							temperature = 0.75,
							max_tokens = 20480,
						},
					},
					moonshot = {
						endpoint = "https://api.moonshot.ai/v1",
						model = "kimi-k2-0711-preview",
						timeout = 30000, -- Timeout in milliseconds
						extra_request_body = {
							temperature = 0.75,
							max_tokens = 32768,
						},
					},
					openai = {
						endpoint = "https://api.openai.com/v1",
						model = "gpt-5.4",
						timeout = 30000, -- Timeout in milliseconds
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
				--- The below dependencies are optional,
				"echasnovski/mini.pick", -- for file_selector provider mini.pick
				"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
				"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
				"ibhagwan/fzf-lua", -- for file_selector provider fzf
				"stevearc/dressing.nvim", -- for input provider dressing
				"folke/snacks.nvim", -- for input provider snacks
				"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
				"zbirenbaum/copilot.lua", -- for providers='copilot'
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						-- recommended settings
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							-- required for Windows users
							use_absolute_path = true,
						},
					},
				},
				{
					-- Make sure to set this up properly if you have lazy=true
					"MeanderingProgrammer/render-markdown.nvim",
					opts = {
						file_types = { "markdown", "Avante" },
					},
					ft = { "markdown", "Avante" },
				},
			},
		},
		{
			"junegunn/fzf",
			build = function()
				vim.fn["fzf#install"]()
			end, -- Install fzf binary
			lazy = false, -- Load fzf immediately
		},
		{
			"junegunn/fzf.vim",
			dependencies = { "junegunn/fzf" },
			config = function()
				-- Optional: Add custom key mappings or commands for fzf.vim
				-- vim.api.nvim_set_keymap("n", "<C-p>", ":Files<CR>", { noremap = true, silent = true })
				-- vim.api.nvim_set_keymap("n", "<leader>b", ":Buffers<CR>", { noremap = true, silent = true })
				-- vim.api.nvim_set_keymap("n", "<leader>g", ":GFiles<CR>", { noremap = true, silent = true })
				-- vim.api.nvim_set_keymap("n", "<leader>l", ":Lines<CR>", { noremap = true, silent = true })
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
		-- Finder --
		-- {
		-- 	"nvim-tree/nvim-tree.lua",
		-- 	version = "*",
		-- 	lazy = false,
		-- 	dependencies = {
		-- 		"nvim-tree/nvim-web-devicons",
		-- 	},
		-- 	config = function()
		-- 		require("nvim-tree").setup({})
		-- 	end,
		-- },
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			lazy = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
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
									{ oldUri = vim.uri_from_fname(old_path), newUri = vim.uri_from_fname(new_path) },
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
								-- ensure avante sidebar is open
								if not open then
									require("avante.api").ask()
									sidebar = require("avante").get()
								end

								sidebar.file_selector:add_selected_file(relative_path)

								-- remove neo tree buffer
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
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = {
					"nvim-lua/plenary.nvim",
					-- Uncomment whichever supported plugin(s) you use
					-- "nvim-tree/nvim-tree.lua",
					"nvim-neo-tree/neo-tree.nvim",
					-- "simonmclean/triptych.nvim"
				},
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
		},
		{
			"stevearc/oil.nvim",
			---@module 'oil'
			---@type oil.SetupOpts
			opts = { default_file_explorer = true },
			-- Optional dependencies
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
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
			keys = { -- Example mapping to toggle outline
				{ "<leader>o", "<cmd>Outline!<CR>", desc = "Toggle outline w/o focus" },
				{ "<F3>", "<cmd>Outline!<CR>", desc = "Toggle outline w/o focus" },
			},
			opts = {
				-- Your setup opts here
			},
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
			"roobert/tailwindcss-colorizer-cmp.nvim",
			-- optionally, override the default options:
			config = function()
				require("tailwindcss-colorizer-cmp").setup({
					color_square_width = 2,
				})
			end,
		},

		-- ################### Colorschemes ###################
		{ "morhetz/gruvbox" }, -- Provides the Gruvbox color scheme, loaded immediately
		{ "NLKNguyen/papercolor-theme" }, -- Offers a highly readable color scheme
		{ "sainnhe/sonokai" }, -- Provides the Sonokai color scheme
		{
			"joshdick/onedark.vim",
			config = function()
				vim.g.onedark_terminal_italics = 1
			end,
		}, -- Offers the One Dark color scheme
		{ "rakr/vim-one" }, -- Provides the One color scheme from Atom editor
		{ "sainnhe/edge" }, -- Offers the Edge color scheme
		{ "connorholyday/vim-snazzy" }, -- Provides the Snazzy color scheme
		{ "junegunn/seoul256.vim" }, -- Seoul256 color scheme
		{
			"nanotech/jellybeans.vim",
		}, -- Colorful, dark color scheme
		{
			"sainnhe/everforest",
			config = function()
				vim.g.everforest_background = "soft"
			end,
		}, -- Green-based warm color scheme
		{
			"loctvl842/monokai-pro.nvim",
			lazy = false,
			priority = 1000,
			opts = {
				transparent_background = true,
			},
			config = function()
				vim.cmd("colorscheme monokai-pro")
			end,
		},
		{ "patstockwell/vim-monokai-tasty" }, -- Monokai-tasty color scheme
		{
			"sonph/onehalf",
			lazy = { rtp = "vim" },
		}, -- Light/Dark color scheme based on Atom's One
		{
			"tomasr/molokai",
		}, -- Molokai color scheme
		{ "bluz71/vim-moonfly-colors" }, -- Dark color scheme with vibrant colors
		{ "cocopon/iceberg.vim" }, -- Dark blue color scheme
		{ "ghifarit53/tokyonight-vim" }, -- Tokyo Night color scheme
		{ "bluz71/vim-nightfly-guicolors" }, -- Dark color scheme with bright accents
		{ "mangeshrex/everblush.vim" }, -- Soft, dark color scheme with vibrant colors
		{ "tjdevries/colorbuddy.nvim" }, -- Helper for creating Neovim color schemes
		{
			"bbenzikry/snazzybuddy.nvim",
			--	    name = 'snazzybuddy',
			--	    lazy = false,
			--	    priority = 1000,
			--	    config = snazzybuddy
		}, -- Clean, vibrant color scheme based on Hyper Snazzy
		{
			"catppuccin/nvim",
			--	    name = "catppuccin",
			--	    lazy = false,
			--	    priority = 1000,
			--	    config = catppuccin_frappe
		}, -- Smooth and comfy Neovim color scheme
		{ "rebelot/kanagawa.nvim" },
		{
			"shawilly/ponokai",
			lazy = false,
			priority = 1000,
			config = function()
				vim.g.sonokai_enable_italic = true
			end,
		},
		{
			"marko-cerovac/material.nvim",
			config = function()
				vim.g.material_style = "lighter"
			end,
		},
		{
			"kaicataldo/material.vim",
			config = function()
				vim.g.material_theme_style = "dark-community"
			end,
		},
		{
			"rose-pine/neovim",
			name = "rose-pine",
			-- config = function()
			-- 	require("rose-pine").setup({
			-- 	})
			-- end,
		},
		{
			"drewtempelmeyer/palenight.vim",
			config = function()
				vim.g.palenight_terminal_italics = true
			end,
		},
		{ "ayu-theme/ayu-vim" },
	})

	local filetypes = {
		"bash",
		"sh",
		-- "zsh", -- bash
		"c", -- c
		"cmake", -- cmake
		-- comment는 별도 filetype 없음 (다른 언어 내 주석)
		"cpp",
		"c++",
		"cc",
		"cxx", -- cpp
		"css", -- css
		"csv", -- csv
		"dockerfile",
		"docker", -- dockerfile
		-- git_config, git_rebase, gitattributes, gitcommit, gitignore는 자동 감지
		"go", -- go
		"graphql",
		"gql", -- graphql
		"helm", -- helm
		"html",
		"htm", -- html
		"http", -- http
		"java", -- java
		"javascript",
		"js",
		"mjs", -- javascript
		"jq", -- jq
		"json",
		"jsonc", -- json
		"lua", -- lua
		"make",
		"makefile", -- make
		"markdown",
		"md", -- markdown
		-- markdown_inline은 별도 filetype 없음 (markdown 내부)
		"mermaid", -- mermaid
		"nginx", -- nginx
		-- objdump는 별도 filetype 없음
		"ps1",
		"psm1",
		"powershell", -- powershell
		"python",
		"py",
		"pyi", -- python
		"regex", -- regex
		-- requirements는 보통 requirements.txt로 python filetype
		"scss", -- scss
		"sql", -- sql
		-- ssh_config는 자동 감지
		"svelte", -- svelte
		"toml", -- toml
		"tsx",
		"typescriptreact", -- tsx
		"typescript",
		"ts", -- typescript
		"vim", -- vim
		"vue",
		-- vimdoc는 help 파일용 (별도 설정 불필요)
		"xml", -- xml
		"yaml",
		"yml", -- yaml
	}

	---------------------------------------------------------------------------------------
	--- Local Function
	-- Function to add C++ headers
	local function cpplang_header()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {
			"#include <iostream>",
			"using namespace std;",
		})
	end

	-- Define the SplitBelow function
	local function SplitBelow()
		vim.cmd("split")
		vim.cmd("wincmd J")
	end

	-- Define the RunSplitPython function
	local function RunSplitExecutor(executor, inputFile, outputFile)
		for i = 1, vim.fn.winnr("$") do
			if vim.fn.getwinvar(i, "&buftype") == "terminal" then
				vim.cmd(i .. "wincmd c")
				break
			end
		end

		SplitBelow()
		vim.cmd("resize 10")
		vim.cmd("term " .. executor .. " " .. inputFile .. " " .. outputFile)
	end

	-- F5 키를 눌렀을 때 실행할 함수를 설정합니다.
	local function RunCode()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:match("%.py$") then
			RunSplitExecutor("python3", bufname, "")
		elseif bufname:match("%.js$") then
			RunSplitExecutor("node", bufname, "")
		elseif bufname:match("%.ts$") then
			RunSplitExecutor("ts-node", bufname, "")
		elseif bufname:match("%.scss$") then
			local filename = bufname:gsub("%.scss$", "")
			RunSplitExecutor("sass", bufname, filename .. ".css")
		elseif bufname:match("%.go$") then
			RunSplitExecutor("go run", bufname, "")
		end
	end

	---------------------------------------------------------------------------------------
	--- Keymap
	vim.keymap.set("n", "gd", "<C-]>", { noremap = true })
	vim.keymap.set("n", "gb", "<C-o>", { noremap = true })
	vim.keymap.set("n", "gn", "<C-i>", { noremap = true })
	vim.keymap.set("n", "gnt", "<C-w><C-]><C-w>T", { noremap = true })
	vim.keymap.set("n", "gnv", "<C-w>v<C-w>l<C-]>", { noremap = true })
	vim.keymap.set("n", "gnh", "<C-w>s<C-]>", { noremap = true })

	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true })
	vim.keymap.set("n", "<F5>", RunCode, { noremap = true })
	vim.keymap.set("", "<C-c>", "<Esc>", { noremap = true, silent = true })
	vim.keymap.set("n", ":ㅂ<CR>", ":q<CR>", { silent = true })
	vim.keymap.set("n", ":ㅈ<CR>", ":w<CR>", { silent = true })
	vim.keymap.set("n", ":ㅌ<CR>", ":x<CR>", { silent = true })

	vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code " })

	-- Clipboard
	vim.keymap.set("n", "y", '"+y', { noremap = true })
	vim.keymap.set("v", "y", '"+y', { noremap = true })

	vim.keymap.set("n", "Y", '"+Y', { noremap = true })
	vim.keymap.set("v", "Y", '"+Y', { noremap = true })

	vim.keymap.set("n", "x", '"+x', { noremap = true })
	vim.keymap.set("v", "x", '"+x', { noremap = true })

	vim.keymap.set("v", "d", '"+d', { noremap = true })
	vim.keymap.set("n", "D", '"+D', { noremap = true })
	vim.keymap.set("v", "D", '"+D', { noremap = true })

	vim.keymap.set("n", "c", '"+c', { noremap = true })

	vim.keymap.set("n", "s", '"+s', { noremap = true })
	vim.keymap.set("v", "s", '"+s', { noremap = true })

	vim.keymap.set("n", "S", '"+S', { noremap = true })
	vim.keymap.set("v", "S", '"+S', { noremap = true })

	vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFileHistory<CR>", { desc = "DiffviewFileHistory" })
	vim.keymap.set("n", "<leader>gb", function()
		local wins = vim.api.nvim_list_wins()
		for _, win in ipairs(wins) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if ft == "gitsigns-blame" then
				vim.api.nvim_win_close(win, true)
				return
			end
		end
		require("gitsigns").blame()
	end)

	---------------------------------------------------------------------------------------
	--- Autocommand
	-- FileType 이벤트에 대한 자동 명령을 설정합니다.
	vim.api.nvim_create_autocmd("FileType", {
		pattern = {
			"typescript",
			"javascript",
			"html",
			"css",
			"javascriptreact",
			"typescriptreact",
			"lua",
		},
		callback = function()
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
			vim.opt_local.softtabstop = 2
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "json",
		callback = function()
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
			vim.opt_local.softtabstop = 2
			vim.g.conceallevel = 0
			vim.g.vim_json_conceal = 0
		end,
	})

	-- Add headers for new .cc files
	vim.api.nvim_create_autocmd("BufNewFile", {
		pattern = "*.cc",
		callback = cpplang_header,
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			-- buf_request_sync defaults to a 1000ms timeout. Depending on your
			-- machine and codebase, you may want longer. Add an additional
			-- argument after params if you find that you have to write the file
			-- twice for changes to be saved.
			-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
			for cid, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
						vim.lsp.util.apply_workspace_edit(r.edit, enc)
					end
				end
			end
			vim.lsp.buf.format({ async = false })
		end,
	})

	-- Open quickfix list in vsplit
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			vim.keymap.set("n", "<C-v>", function()
				local item = vim.fn.getqflist()[vim.fn.line(".")]
				vim.cmd("wincmd p") -- 이전 창으로 포커스 이동
				vim.cmd("vsplit")
				vim.cmd("buffer " .. item.bufnr)
				vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
			end, { buffer = true })
		end,
	})

	-- Close quickfix
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true })
		end,
	})

	--- User Command
	vim.api.nvim_create_user_command("Q", "q", { nargs = 0 })
	vim.api.nvim_create_user_command("Nt", "Neotree toggle", {})
	vim.api.nvim_create_user_command("Sp", SplitBelow, {})
	vim.api.nvim_create_user_command("Tn", "tabnew", { nargs = "*" })
	vim.api.nvim_create_user_command("Pwd", "echo expand('%:p')", { nargs = "*" })
	vim.api.nvim_create_user_command("Format", function()
		require("conform").format({ lsp_fallback = false, timeout_ms = 1000 })
	end, { nargs = "*" })
	vim.api.nvim_create_user_command("CC", "ClaudeCode", { nargs = 0 })
	vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { nargs = 0 })
	vim.api.nvim_create_user_command("Blame", "Gitsigns blame", { nargs = 0 })
	vim.api.nvim_create_user_command("BlameLine", "Gitsigns blame_line", { nargs = 0 })

	--- LSP
	-- Enable (broadcasting) snippet capability for completion
	-- local capabilities = vim.lsp.protocol.make_client_capabilities()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	vim.lsp.config("cssls", {
		capabilities = capabilities,
	})
	vim.lsp.config("html", {
		capabilities = capabilities,
	})
	vim.lsp.config("jsonls", {
		capabilities = capabilities,
	})
	local base_on_attach = vim.lsp.config.eslint.on_attach
	vim.lsp.config("eslint", {
		on_attach = function(client, bufnr)
			if not base_on_attach then
				return
			end

			base_on_attach(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "LspEslintFixAll",
			})
		end,
	})
	vim.lsp.config("jdtls", {
		capabilities = capabilities,
	})
	-- If you are using mason.nvim, you can get the ts_plugin_path like this
	-- For Mason v1,
	-- local mason_registry = require('mason-registry')
	-- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
	-- For Mason v2,
	-- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
	-- or even
	-- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

	local vue_language_server_path = vim.fn.expand("$MASON/packages")
		.. "/vue-language-server"
		.. "/node_modules/@vue/language-server"
	local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

	local vue_plugin = {
		name = "@vue/typescript-plugin",
		location = vue_language_server_path,
		languages = { "vue" },
		configNamespace = "typescript",
	}

	local vtsls_config = {
		-- vtsls or ts_ls
		on_attach = function(client)
			local existing_capabilities = client.server_capabilities
			if vim.bo.filetype == "vue" then
				existing_capabilities.semanticTokensProvider.full = false
			else
				existing_capabilities.semanticTokensProvider.full = true
			end
		end,
		settings = {
			vtsls = {
				tsserver = {
					globalPlugins = {
						vue_plugin,
					},
				},
			},
		},
		filetypes = tsserver_filetypes,
	}
	vim.lsp.config("vtsls", vtsls_config)

	local ts_ls_config = {
		on_attach = function(client)
			local existing_capabilities = client.server_capabilities
			if vim.bo.filetype == "vue" then
				existing_capabilities.semanticTokensProvider.full = false
			else
				existing_capabilities.semanticTokensProvider.full = true
			end
		end,
		init_options = {
			plugins = {
				vue_plugin,
			},
		},
		filetypes = tsserver_filetypes,
	}
	vim.lsp.config("ts_ls", ts_ls_config)

	vim.lsp.config("lua_ls", {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most
					-- likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Tell the language server how to find Lua modules same way as Neovim
					-- (see `:h lua-module-load`)
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
						vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
						-- Depending on the usage, you might want to add additional paths
						-- here.
						-- '${3rd}/luv/library',
						-- '${3rd}/busted/library',
					},
					-- Or pull in all of 'runtimepath'.
					-- NOTE: this is a lot slower and will cause issues when working on
					-- your own configuration.
					-- See https://github.com/neovim/nvim-lspconfig/issues/3189
					-- library = vim.api.nvim_get_runtime_file('', true),
				},
			})
		end,
		settings = {
			Lua = {},
		},
	})
	vim.lsp.enable({
		"gopls",
		"pyright",
		-- "vtsls",
		"vue_ls",
		"ts_ls",
		"lua_ls",
		"tailwindcss",
		"cssls",
		-- "css_variables",
		-- "cssmodules_ls",
		"html",
		"jsonls",
		"eslint",
		"dockerls",
		"docker_compose_language_service",
		"jdtls",
		"sourcekit",
	})
end
