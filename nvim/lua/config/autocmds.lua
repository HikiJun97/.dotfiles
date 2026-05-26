-- lua/config/autocmds.lua

-- 웹 파일타입: 2칸 들여쓰기
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

-- JSON 설정
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

-- 새 .cc 파일: C++ 헤더 자동 삽입
vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.cc",
	callback = function()
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {
			"#include <iostream>",
			"using namespace std;",
		})
	end,
})

-- Go: 저장 시 imports 정리
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
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

-- Quickfix: <C-v>로 vsplit 열기
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "<C-v>", function()
			local item = vim.fn.getqflist()[vim.fn.line(".")]
			vim.cmd("wincmd p")
			vim.cmd("vsplit")
			vim.cmd("buffer " .. item.bufnr)
			vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
		end, { buffer = true })
	end,
})

-- Quickfix: q로 닫기
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function()
		vim.keymap.set("n", "q", "<cmd>cclose<cr>", { buffer = true })
	end,
})
