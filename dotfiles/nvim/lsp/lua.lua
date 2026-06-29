--- @type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".git",
    ".luacheckrc",
    ".luarc.json",
    ".luarc.jsonc",
    ".stylua.toml",
    "selene.toml",
    "selene.yml",
    "stylua.toml",
  },
  single_file_support = true,
  telemetry = { enabled = false },
  log_level = vim.lsp.protocol.MessageType.Warning,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
      workspace = {
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
  on_attach = function(client, _)
    -- Work around Neovim semantic token state errors with lua-language-server.
    -- Treesitter already handles Lua highlighting well enough here.
    client.server_capabilities.semanticTokensProvider = nil

    if client.server_capabilities.completionProvider then
      client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }
    end
  end,
}
