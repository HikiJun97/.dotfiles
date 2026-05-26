-- lua/config/lsp.lua

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("cssls", { capabilities = capabilities })
vim.lsp.config("html", { capabilities = capabilities })
vim.lsp.config("jsonls", { capabilities = capabilities })
vim.lsp.config("jdtls", { capabilities = capabilities })

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

local function ts_on_attach(client)
	local existing_capabilities = client.server_capabilities
	if vim.bo.filetype == "vue" then
		existing_capabilities.semanticTokensProvider.full = false
	else
		existing_capabilities.semanticTokensProvider.full = true
	end
end

vim.lsp.config("vtsls", {
	on_attach = ts_on_attach,
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = { vue_plugin },
			},
		},
	},
	filetypes = tsserver_filetypes,
})

vim.lsp.config("ts_ls", {
	on_attach = ts_on_attach,
	init_options = {
		plugins = { vue_plugin },
	},
	filetypes = tsserver_filetypes,
})

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
				version = "LuaJIT",
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
				},
			},
		})
	end,
	settings = { Lua = {} },
})

vim.lsp.enable({
	"gopls",
	"pyright",
	"vue_ls",
	"ts_ls",
	"lua_ls",
	"tailwindcss",
	"cssls",
	"html",
	"jsonls",
	"eslint",
	"dockerls",
	"docker_compose_language_service",
	"jdtls",
	"sourcekit",
})
