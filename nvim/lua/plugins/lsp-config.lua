-- lua/plugins/lsp-config.lua
-- Robust cross-version mason-lspconfig + lspconfig setup
-- Works with pre-2.0 (setup_handlers) and v2+ (vim.lsp.config) APIs.

local ok_mason, mason = pcall(require, "mason")
local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
local ok_lspconfig, lspconfig = pcall(require, "lspconfig")

if not ok_mason or not ok_mason_lsp or not ok_lspconfig then
  vim.notify("LSP setup: missing mason / mason-lspconfig / lspconfig", vim.log.levels.ERROR)
  return
end

-- servers to ensure (mason-lspconfig names)
local servers = { "lua_ls", "ts_ls" }

-- Ensure mason is initialized and request these installers
mason.setup()
-- safe call (harmless if called elsewhere)
pcall(function() mason_lsp.setup({ ensure_installed = servers }) end)

-- common capabilities and on_attach
local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = function(client, bufnr)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
end

-- helper to safely setup via lspconfig table
local function safe_lspconfig_setup(name, opts)
  opts = opts or {}
  opts.on_attach = opts.on_attach or on_attach
  opts.capabilities = opts.capabilities or capabilities
  if lspconfig[name] then
    lspconfig[name].setup(opts)
  else
    vim.notify(("lspconfig: no server named %s"):format(name), vim.log.levels.WARN)
  end
end

-- If old mason-lspconfig with setup_handlers is present -> use it (pre-2.0)
if type(mason_lsp.setup_handlers) == "function" then
  mason_lsp.setup_handlers({
    -- default handler for servers with no custom config
    function(server_name)
      safe_lspconfig_setup(server_name)
    end,
    -- Lua custom config
    ["lua_ls"] = function()
      safe_lspconfig_setup("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      })
    end,
    -- ts_ls default
    ["ts_ls"] = function()
      safe_lspconfig_setup("ts_ls")
    end,
	["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,
  })

  return -- done for old API
end

-- Otherwise (mason-lspconfig v2+), use native vim.lsp.config API.
-- Configure servers using vim.lsp.config (or put per-server files in after/lsp/)
-- Note: require("nvim-lspconfig") must be in runtimepath (it is, because we required lspconfig earlier)

-- Lua config via native API
if vim.lsp and vim.lsp.config then
  -- server-specific settings for lua_ls
  vim.lsp.config("lua_ls", {
    -- these top-level fields are merged into the server's config
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      },
    },
  })

  -- ts_ls
  vim.lsp.config("ts_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  -- If you want to automatically start servers when files are opened,
  -- you can rely on lspconfig's usual behavior (lspconfig will attach servers),
  -- and mason-lspconfig will ensure the installers exist.
else
  -- As a final fallback (shouldn't be needed), call lspconfig setup directly:
  safe_lspconfig_setup("lua_ls", {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
      },
    },
  })
  safe_lspconfig_setup("ts_ls")
end

