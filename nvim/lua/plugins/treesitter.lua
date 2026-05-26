-- lua/plugins/treesitter.lua

local languages = {
	"bash", "c", "cmake", "comment", "cpp", "css", "csv", "dockerfile",
	"git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
	"go", "graphql", "helm", "html", "http", "java", "javascript", "jq",
	"json", "lua", "make", "markdown", "markdown_inline", "mermaid", "nginx",
	"objdump", "powershell", "python", "regex", "requirements", "scss", "sql",
	"ssh_config", "svelte", "swift", "toml", "tsx", "typescript", "vim",
	"vimdoc", "vue", "xml", "yaml",
}

return {
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
				end,
			})
		end,
	},
}
