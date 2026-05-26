-- lua/config/keymaps.lua

local commands = require("config.commands")

-- 태그 탐색 (LSP 미사용 시 폴백)
vim.keymap.set("n", "gd", "<C-]>", { noremap = true })
vim.keymap.set("n", "gb", "<C-o>", { noremap = true })
vim.keymap.set("n", "gn", "<C-i>", { noremap = true })
vim.keymap.set("n", "gnt", "<C-w><C-]><C-w>T", { noremap = true })
vim.keymap.set("n", "gnv", "<C-w>v<C-w>l<C-]>", { noremap = true })
vim.keymap.set("n", "gnh", "<C-w>s<C-]>", { noremap = true })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true })

-- LSP 참조 (현재 파일만 필터링)
vim.keymap.set("n", "grR", function()
	vim.lsp.buf.references(nil, {
		on_list = function(options)
			local current = vim.api.nvim_buf_get_name(0)
			options.items = vim.tbl_filter(function(item)
				return item.filename == current
			end, options.items)
			vim.fn.setqflist({}, " ", options)
			vim.cmd("botright copen")
		end,
	})
end)

-- 코드 실행
vim.keymap.set("n", "<F5>", commands.RunCode, { noremap = true })

-- Escape
vim.keymap.set("", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- 한글 입력 모드 명령
vim.keymap.set("n", ":ㅂ<CR>", ":q<CR>", { silent = true })
vim.keymap.set("n", ":ㅈ<CR>", ":w<CR>", { silent = true })
vim.keymap.set("n", ":ㅌ<CR>", ":x<CR>", { silent = true })

-- Claude Code 토글
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })

-- 클립보드 (시스템 클립보드로 yank/delete/change)
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

-- Diffview
vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFileHistory<CR>", { desc = "DiffviewFileHistory" })
vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "DiffviewOpen" })
