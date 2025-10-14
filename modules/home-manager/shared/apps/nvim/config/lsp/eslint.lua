local eslint_config_files = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

---@type vim.lsp.Config
return {
  cmd = { "vscode-eslint-language-server", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
    "astro",
    "htmlangular",
  },
  root_markers = eslint_config_files,
  workspace_required = true,
  settings = {
    workingDirectory = { mode = "auto" },
    nodePath = "",
    validate = "on",
    useESLintClass = false,
    experimental = {
      useFlatConfig = false,
    },
    format = false,
    quiet = false,
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(
      0,
      "LspEslintFixAll",
      function()
        client:request_sync("workspace/executeCommand", {
          command = "eslint.applyAllFixes",
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = vim.lsp.util.buf_versions[bufnr],
            },
          },
        }, nil, bufnr)
      end,
      {}
    )
  end,
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if result then vim.ui.open(result.url) end
      return {}
    end,
    ["eslint/confirmESLintExecution"] = function(_, result)
      if not result then return end
      return 4 -- approved
    end,
    ["eslint/probeFailed"] = function()
      vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
      return {}
    end,
    ["eslint/noLibrary"] = function()
      vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
      return {}
    end,
  },
}
