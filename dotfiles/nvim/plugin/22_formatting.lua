Pack.later(function()
  Pack.add({ "https://github.com/stevearc/conform.nvim" })

  local web_formatter = vim.fn.executable("oxfmt") == 1 and { "oxfmt" } or { "prettier" }
  local function with_web_root_markers(extra)
    return require("conform.util").root_file(vim.tbl_extend("force", {
      ".git",
      "package.json",
    }, extra))
  end

  local Conform = require("conform")

  Conform.setup({
    formatters_by_ft = {
      ["*"] = { "trim_whitespace" },
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      sh = { "beautysh" },
      bash = { "beautysh" },
      zsh = { "beautysh" },
      dart = { "dart_format" },
      json = web_formatter,
      html = web_formatter,
      typescript = web_formatter,
      typescriptreact = web_formatter,
      javascript = web_formatter,
      javascriptreact = web_formatter,
    },
    formatters = {
      prettier = {
        cwd = with_web_root_markers({
          "prettier.config.js",
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.js",
        }),
      },
      oxfmt = {
        cwd = with_web_root_markers({
          "oxlintrc.json",
          ".oxlintrc.json",
        }),
      },
    },
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  local function format() Conform.format({ lsp_fallback = true }) end

  Util.map_keys({
    { "<leader>ff", format, opts = { desc = "Format File" } },
  })
end)
