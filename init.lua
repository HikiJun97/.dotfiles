-- Ubuntu
-- Basic settings
-- vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}

vim.opt.mouse = "a"
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.wildmode = "longest,list"
vim.opt.autowrite = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.ruler = true
vim.opt.incsearch = true

vim.opt.scrolloff = 2
vim.opt.history = 256
vim.opt.laststatus = 2

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.cmd([[abbr funciton function]])

-- tags setting
vim.opt.tags:append("./tags,tags")
vim.api.nvim_set_keymap("n", "<C-[>", "<Esc>:po<CR>", { noremap = true })

-- Auto commands
vim.cmd([[
  set autoread
  au CursorHold,CursorHoldI * silent! checktime
]])

-- More settings
vim.cmd([[
  au FileType *.cc,*.cpp,*.cc setlocal cindent
]])

-- FileType 이벤트에 대한 자동 명령을 설정합니다.
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "html", "css" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if string.match(bufname, "docker-compose.yml") then
			vim.bo.filetype = "yaml.docker-compose"
		elseif string.match(bufname, "compose.yml") then
			vim.bo.filetype = "yaml.docker-compose"
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		-- json 파일의 들여쓰기를 2로 설정
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
		vim.g.conceallevel = 0
		vim.g.vim_json_conceal = 0
	end,
})

-- g:coc_filetype_map 설정
vim.g.coc_filetype_map = {
	["yaml.docker-compose"] = "dockercompose",
}
vim.opt.backspace = "eol,start,indent"
vim.opt.foldmethod = "indent"

-- Encoding and backup settings
vim.opt.encoding = "utf-8"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.fileencodings = "utf-8,euc-kr"
vim.opt.tags = "./tags;"
vim.opt.statusline = "%<%l:%v [%P]%=%a %h%m%r %F"

-- True colors settings
vim.cmd([[
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif
]])

-- Setting global variables
vim.g["one_allow_italics"] = 1

-- Autocommands
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
			vim.api.nvim_exec('norm g`"', false)
		end
	end,
}) -- remember cursor position

-- Syntax enable
if vim.fn.has("syntax") == 1 then
	vim.cmd("syntax on")
end

vim.cmd("filetype off")

-- If lazy.nvim not installed, install it.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "vim-scripts/taglist.vim" },                        -- Displays a list of tags (functions, variables, etc.) in the source code
	{ "SirVer/ultisnips",       event = { "InsertEnter" } }, -- Manages and quickly inserts snippets (code fragments)
	{ "honza/vim-snippets" },                             -- Collection of snippets for various programming languages
	{
		"davidhalter/jedi-vim",
		config = function()
			vim.g["jedi#show_call_signatures"] = 0
			vim.g["jedi#popup_select_first"] = "0"
			vim.g["jedi#force_py_version"] = 3
		end,
	}, -- Auto-completion for Python code
	-- {
	-- 	"hynek/vim-python-pep8-indent",
	-- 	config = function()
	-- 		vim.g.python_pep8_indent_multiline_string = -1
	-- 	end,
	-- }, -- Applies PEP 8 style indentation to Python code
	{ "nvie/vim-flake8" },                                    -- Grammar check for Python code
	{ "anscoral/winmanager.vim" },                            -- Enhances window management capabilities
	{ "shime/vim-livedown" },                                 -- Markdown preview functionality
	{ "tpope/vim-sensible" },                                 -- Sensible default settings for Vim
	{ "junegunn/fzf",           lazy = { event = "VimEnter" } }, -- Fuzzy file finder
	{ "junegunn/goyo.vim" },                                  -- Distraction-free writing mode
	-- { "thaerkh/vim-indentguides" }, -- Visual display of indent levels
	{
		"nathanaelkane/vim-indent-guides",
		config = function()
			vim.g.indent_guides_enable_on_vim_startup = 1
			vim.g.indent_guides_start_level = 2
			vim.g.indent_guides_guide_size = 1
		end,
	},
	{ "Raimondi/delimitMate" },                 -- Auto-completion for quotes, parens, brackets, etc.
	{ "preservim/nerdtree" },                   -- Tree explorer for navigating the filesystem
	{ "blueyed/vim-diminactive" },              -- Dim inactive windows
	{ "majutsushi/tagbar" },                    -- Displays tags in a sidebar
	{ "PhilRunninger/nerdtree-visual-selection" }, -- Enhanced visual selection for NERDTree
	{ "ctrlpvim/ctrlp.vim" },                   -- Full path fuzzy file, buffer, tag, etc. finder
	{
		"neoclide/coc.nvim",
		branch = "release",
	}, -- Intellisense engine for Vim8 & Neovim
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"c",
					"cpp",
					"go",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"elixir",
					"heex",
					"javascript",
					"html",
					"python",
					"java",
					"json",
					"css",
				},
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				--indent = { enable = true },
			})
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil,  -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
				performance_mode = false, -- Disable "Performance Mode" on all buffers.
			})
		end,
	},
	-- 	{ "pangloss/vim-javascript" }, -- JavaScript bundle for Vim
	-- 	{ "mxw/vim-jsx" },          -- React JSX syntax highlighting and indenting
	{ "uiiaoo/java-syntax.vim" }, -- Improved Java syntax highlighting
	{ "tpope/vim-surround" },  -- Quoting/parenthesizing made simple
	{ "alvan/vim-closetag" },  -- Auto close (X)HTML tags
	{ "nvim-lua/plenary.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-tree/nvim-web-devicons" },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
					-- Use a sub-list to run only the first available formatter
					-- javascript = { { "prettierd", "prettier" } },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
	{
		"stsewd/isort.nvim",
		run = ":UpdateRemotePlugins",
		config = function()
			vim.g.isort_command = "isort"
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		-- config = function()
		-- end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
		end,
	},
	{
		"sbdchd/neoformat",
		config = function()
			vim.g.neoformat_try_node_exe = 1
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	-- ################### UI plugins ###################
	-- { "itchyny/lightline.vim" },       -- Provides a lightweight status line
	-- { "vim-airline/vim-airline" },     -- Provides enhanced status lines and themes
	-- { "vim-airline/vim-airline-themes" }, -- Additional theme collection for the Airline plugin
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

	-- ################### Color schemes ###################
	{
		"morhetz/gruvbox",
		--        config = function()
		--            vim.cmd([[colorscheme gruvbox]])
		--        end,
	},                             -- Provides the Gruvbox color scheme, loaded immediately
	{ "NLKNguyen/papercolor-theme" }, -- Offers a highly readable color scheme
	{ "sainnhe/sonokai" },         -- Provides the Sonokai color scheme
	{
		"joshdick/onedark.vim",
	},                           -- Offers the One Dark color scheme
	{ "rakr/vim-one" },          -- Provides the One color scheme from Atom editor
	{ "sainnhe/edge" },          -- Offers the Edge color scheme
	{ "connorholyday/vim-snazzy" }, -- Provides the Snazzy color scheme
	{ "junegunn/seoul256.vim" }, -- Seoul256 color scheme
	{
		"nanotech/jellybeans.vim",
	},                                 -- Colorful, dark color scheme
	{ "sainnhe/everforest" },          -- Green-based warm color scheme
	{ "patstockwell/vim-monokai-tasty" }, -- Monokai color scheme
	{
		"sonph/onehalf",
		lazy = { rtp = "vim" },
	}, -- Light/Dark color scheme based on Atom's One
	{
		"tomasr/molokai",
	},                                -- Molokai color scheme
	{ "bluz71/vim-moonfly-colors" },  -- Dark color scheme with vibrant colors
	{ "cocopon/iceberg.vim" },        -- Dark blue color scheme
	{ "ghifarit53/tokyonight-vim" },  -- Tokyo Night color scheme
	{ "bluz71/vim-nightfly-guicolors" }, -- Dark color scheme with bright accents
	{ "mangeshrex/everblush.vim" },   -- Soft, dark color scheme with vibrant colors
	{ "tjdevries/colorbuddy.nvim" },  -- Helper for creating Neovim color schemes
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
	{ "rebelot/kanagawa.nvim" }
})

vim.cmd("colorscheme kanagawa")

-- vim.api.nvim_create_user_command("Format", function(args)
-- 	local range = nil
-- 	if args.count ~= -1 then
-- 		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
-- 		range = {
-- 			start = { args.line1, 0 },
-- 			["end"] = { args.line2, end_line:len() },
-- 		}
-- 	end
-- 	require("conform").format({ async = true, lsp_fallback = true, range = range })
-- end, { range = true })

vim.cmd("filetype plugin indent on")

local keyset = vim.keymap.set
vim.g.mapleader = "\\"
-- Autocomplete
function _G.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gb", "<C-o>", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold",
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

-- Formatting selected code
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", { silent = true })

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
	group = "CocGroup",
	pattern = "typescript,json",
	command = "setl formatexpr=CocAction('formatSelected')",
	desc = "Setup formatexpr specified filetype(s).",
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
	group = "CocGroup",
	pattern = "CocJumpPlaceholder",
	command = "call CocActionAsync('showSignatureHelp')",
	desc = "Update signature help on jump placeholder",
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = { silent = true, nowait = true }
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply source code actions for current file.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = false })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = false })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = false })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true, expr = true }
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
keyset("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
vim.api.nvim_create_user_command("Prettier", function()
	vim.fn.CocAction("runCommand", "prettier.formatFile")
end, {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = "?" })

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
--vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")  -- makes error
--vim.o.statusline = "%{coc#status()}%{get(b:,'coc_current_function','')}" .. vim.o.statusline  -- GPT said like this

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = { silent = true, nowait = true }
-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

-- UltiSnips settings
vim.g.UltiSnipsExpandTrigger = "<CR>"
vim.g.UltiSnipsJumpForwardTrigger = "<CR>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-CR>"
vim.g.UltiSnipsEditSplit = "vertical"

-- Colorscheme settings
vim.opt.termguicolors = true -- enables 256 colors
vim.opt.background = "dark"  -- sets the background to dark

-- Function to add C++ headers
local function cpplang_header()
	vim.api.nvim_buf_set_lines(0, 0, -1, false, {
		"#include <iostream>",
		"using namespace std;",
	})
end

-- Autocommand to add headers for new .cc files
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.cc",
	callback = cpplang_header,
})

-- 글로벌 변수 설정
vim.g.delimitMate_expand_cr = 1
vim.g.tagbar_sort = 0
vim.g.tagbar_show_visibility = 1
vim.g.tagbar_show_data_type = 1
vim.g.jsx_ext_required = 0

-- NERDTree options
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command =
	[[if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]],
})
-- If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command =
	[[if bufname('#') =~ 'NERD_tree_\\d+' && bufname('%') !~ 'NERD_tree_\\d+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif]],
})

vim.g.tlist_cpp_settings = "c++;c:class;f:function"
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.cc",
	command = "TlistUpdate",
})



-- vim.keymap.set("n", "<F2>", ":NERDTreeToggle | wincmd p<CR>", { noremap = true })
vim.keymap.set("n", "<F2>", ":Neotree toggle<CR>", { noremap = true })
vim.keymap.set("n", "<F3>", ":TlistToggle<CR>", { noremap = true })
vim.keymap.set("n", "<F4>", ":TagbarToggle<CR>", { noremap = true })
vim.keymap.set("n", "<F6>", ":TagbarTogglePause<CR>", { noremap = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.api.nvim_create_user_command("Tn", "tabnew", { nargs = "*" })
--
-- Define the SplitBelow function
local function SplitBelow()
	vim.cmd("split")
	vim.cmd("wincmd J")
end

-- Create a command 'Sp' to call SplitBelow
vim.api.nvim_create_user_command("Sp", SplitBelow, {})

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
	local filename = bufname:gsub("%..+$", "")
	if bufname:match("%.py$") then
		RunSplitExecutor("python", bufname, "")
	elseif bufname:match("%.js$") then
		RunSplitExecutor("node", bufname, "")
	elseif bufname:match("%.ts$") then
		RunSplitExecutor("npx ts-node", bufname, "")
	elseif bufname:match("%.scss$") then
		local filename = bufname:gsub("%.scss$", "")
		RunSplitExecutor("sass", bufname, filename .. ".css")
	end
end

-- 키 매핑 설정: Normal 모드에서 F5 키를 누를 때 RunCode 함수를 실행합니다.
vim.keymap.set("n", "<F5>", RunCode, { noremap = true })

-- -- Visual Mode에서 '='를 한 번 눌렀을 때 :Format 실행
-- vim.api.nvim_set_keymap('x', '=', ':Format<CR>', { noremap = true, silent = true })
--
-- -- Normal Mode에서 '='를 두 번 눌렀을 때 :Format 실행
-- vim.api.nvim_set_keymap('n', '==', ':Format<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command("Prettier", function()
	vim.cmd("CocCommand prettier.forceFormatDocument")
end, { nargs = 0 })

-- Clipboard
vim.api.nvim_set_keymap("n", "y", '"+y', { noremap = true })
vim.api.nvim_set_keymap("v", "y", '"+y', { noremap = true })

vim.api.nvim_set_keymap("n", "Y", '"+Y', { noremap = true })
vim.api.nvim_set_keymap("v", "Y", '"+Y', { noremap = true })

vim.api.nvim_set_keymap("n", "x", '"+x', { noremap = true })
vim.api.nvim_set_keymap("v", "x", '"+x', { noremap = true })

vim.api.nvim_set_keymap("n", "d", '"+d', { noremap = true })
vim.api.nvim_set_keymap("v", "d", '"+d', { noremap = true })
vim.api.nvim_set_keymap("n", "D", '"+D', { noremap = true })
vim.api.nvim_set_keymap("v", "D", '"+D', { noremap = true })

vim.api.nvim_set_keymap("n", "c", '"+c', { noremap = true })

vim.api.nvim_set_keymap("n", "s", '"+s', { noremap = true })
vim.api.nvim_set_keymap("v", "s", '"+s', { noremap = true })

vim.api.nvim_set_keymap("n", "S", '"+S', { noremap = true })
vim.api.nvim_set_keymap("v", "S", '"+S', { noremap = true })

require("neo-tree").setup({
	window = {
		position = "left",
		width = 33,
	},
})
-- vim.api.nvim_set_keymap("n", "p", '"+p', { noremap = true })
-- vim.api.nvim_set_keymap("v", "p", '"+p', { noremap = true })
