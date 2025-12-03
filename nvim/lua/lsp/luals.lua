-- Define config only if it doesn't exist
local configs = vim.lsp.configs

if not configs.lua_ls then
  configs.lua_ls = {
    default_config = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_dir = vim.loop.cwd,
      settings = {},
    },
  }
end

-- Start the LSP client
vim.lsp.start({
  name = "lua_ls",
  cmd = { "lua-language-server" },
  root_dir = vim.loop.cwd,
})

