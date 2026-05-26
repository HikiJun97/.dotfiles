-- init.lua — 엔트리포인트

-- 배경 투명도
vim.cmd([[
    highlight Normal guibg=none
    highlight NonText guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
]])

if vim.g.vscode then
	vim.notify("Running in VSCode-neovim", vim.log.levels.INFO)
	require("vscode")
else
	vim.notify("Running in Neovim", vim.log.levels.INFO)

	require("config.options")
	require("config.colorschemes")

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

	vim.g.mapleader = "\\"
	vim.g.maplocalleader = "\\"

	-- uv tool install --upgrade pynvim
	vim.g.python3_host_prog = vim.fn.expand("~/.local/bin/pynvim-python")

	-- lua/plugins/ 디렉토리 내 모든 파일 자동 임포트
	require("lazy").setup({ { import = "plugins" } })

	-- 플러그인 로드 후 설정 모듈 로드 (플러그인 API 사용 가능)
	require("config.keymaps")
	require("config.autocmds")
	require("config.commands")
	require("config.lsp")
end
