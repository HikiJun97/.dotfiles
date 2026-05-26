-- lua/config/colorschemes.lua
-- Colorschemes loaded via native vim.pack (Neovim 0.11+)

local gh = function(repo)
	return "https://github.com/" .. repo
end

-- Simple colorschemes (no extra config)
vim.pack.add({
	gh("rktjmp/lush.nvim"),
	gh("zenbones-theme/zenbones.nvim"),
	gh("morhetz/gruvbox"),
	gh("NLKNguyen/papercolor-theme"),
	gh("sainnhe/sonokai"),
	gh("sainnhe/gruvbox-material"),
	gh("rakr/vim-one"),
	gh("sainnhe/edge"),
	gh("connorholyday/vim-snazzy"),
	gh("junegunn/seoul256.vim"),
	gh("nanotech/jellybeans.vim"),
	gh("patstockwell/vim-monokai-tasty"),
	gh("tomasr/molokai"),
	gh("bluz71/vim-moonfly-colors"),
	gh("cocopon/iceberg.vim"),
	gh("ghifarit53/tokyonight-vim"),
	gh("bluz71/vim-nightfly-guicolors"),
	gh("mangeshrex/everblush.vim"),
	gh("tjdevries/colorbuddy.nvim"),
	gh("bbenzikry/snazzybuddy.nvim"),
	gh("catppuccin/nvim"),
	gh("rebelot/kanagawa.nvim"),
	gh("ayu-theme/ayu-vim"),
	gh("EdenEast/nightfox.nvim"),
})

-- Colorschemes with extra vim.g config
vim.pack.add({ gh("joshdick/onedark.vim") })
vim.g.onedark_terminal_italics = 1

vim.pack.add({ gh("sainnhe/everforest") })
vim.g.everforest_background = "soft"

vim.pack.add({ gh("loctvl842/monokai-pro.nvim") })
require("monokai-pro").setup({ transparent_background = true })

vim.pack.add({ gh("shawilly/ponokai") })
vim.g.sonokai_enable_italic = true

vim.pack.add({ gh("marko-cerovac/material.nvim") })
vim.g.material_style = "lighter"

vim.pack.add({ gh("kaicataldo/material.vim") })
vim.g.material_theme_style = "dark-community"

vim.pack.add({ gh("rose-pine/neovim") })

vim.pack.add({ gh("drewtempelmeyer/palenight.vim") })
vim.g.palenight_terminal_italics = true

-- sonph/onehalf: rtp 서브디렉터리 수동 지정 필요
vim.pack.add({ gh("sonph/onehalf") })
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/site/pack/core/opt/onehalf/vim")

vim.g.gruvbox_contrast_dark = "soft"
vim.g.gruvbox_contrast_light = "soft"

vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "material"

vim.opt.background = "dark"
vim.cmd.colorscheme("gruvbox-material")
