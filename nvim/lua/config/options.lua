-- lua/config/options.lua

vim.g.clipboard = "osc52"

vim.opt.number = true
vim.opt.autowrite = true
vim.opt.smartcase = true
vim.opt.scrolloff = 2
vim.opt.laststatus = 3

-- 들여쓰기
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

-- 오타 교정
vim.cmd([[abbr funciton function]])

-- 파일 자동 새로고침
vim.cmd([[
  set autoread
  au CursorHold,CursorHoldI * silent! checktime
]])
