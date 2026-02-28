require("nvchad.configs.lspconfig").defaults()

local mason_lspconfig = require "mason-lspconfig"
mason_lspconfig.setup {
  automatic_installation = true,
}

local installed_servers = mason_lspconfig.get_installed_servers()
if #installed_servers > 0 then
  vim.lsp.enable(installed_servers)
end

-- read :h vim.lsp.config for changing options of lsp servers 
