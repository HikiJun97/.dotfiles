-- lua/vscode.lua
-- VSCode-neovim specific configuration

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
