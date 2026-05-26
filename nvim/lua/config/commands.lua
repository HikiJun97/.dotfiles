-- lua/config/commands.lua

local M = {}

-- 수평 분할 후 하단 배치
function M.SplitBelow()
	vim.cmd("split")
	vim.cmd("wincmd J")
end

-- 기존 터미널 닫고 분할 터미널에서 실행
function M.RunSplitExecutor(executor, inputFile, outputFile)
	for i = 1, vim.fn.winnr("$") do
		if vim.fn.getwinvar(i, "&buftype") == "terminal" then
			vim.cmd(i .. "wincmd c")
			break
		end
	end
	M.SplitBelow()
	vim.cmd("resize 10")
	vim.cmd("term " .. executor .. " " .. inputFile .. " " .. outputFile)
end

-- 현재 파일 확장자에 따라 실행
function M.RunCode()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname:match("%.py$") then
		M.RunSplitExecutor("python3", bufname, "")
	elseif bufname:match("%.js$") then
		M.RunSplitExecutor("node", bufname, "")
	elseif bufname:match("%.ts$") then
		M.RunSplitExecutor("ts-node", bufname, "")
	elseif bufname:match("%.scss$") then
		local filename = bufname:gsub("%.scss$", "")
		M.RunSplitExecutor("sass", bufname, filename .. ".css")
	elseif bufname:match("%.go$") then
		M.RunSplitExecutor("go run", bufname, "")
	end
end

-- 사용자 명령
vim.api.nvim_create_user_command("Q", "q", { nargs = 0 })
vim.api.nvim_create_user_command("Nt", "Neotree toggle", {})
vim.api.nvim_create_user_command("Sp", M.SplitBelow, {})
vim.api.nvim_create_user_command("Tn", "tabnew", { nargs = "*" })
vim.api.nvim_create_user_command("Pwd", "echo expand('%:p')", { nargs = "*" })
vim.api.nvim_create_user_command("Format", function()
	require("conform").format({ lsp_fallback = false, timeout_ms = 1000 })
end, { nargs = "*" })
vim.api.nvim_create_user_command("CC", "ClaudeCode", { nargs = 0 })
vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { nargs = 0 })
vim.api.nvim_create_user_command("SS", ":SessionSave", {})
vim.api.nvim_create_user_command("Blame", "Gitsigns blame", { nargs = 0 })
vim.api.nvim_create_user_command("BlameLine", "Gitsigns blame_line", { nargs = 0 })

return M
