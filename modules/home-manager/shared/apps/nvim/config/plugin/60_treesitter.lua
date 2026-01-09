local group = vim.api.nvim_create_augroup("bfmp.treesitter", { clear = true })

_B.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    data = {
      load = function()
        vim.schedule(function()
          ---@diagnostic disable-next-line: param-type-mismatch
          local success = pcall(vim.cmd, ":TSUpdate")
          if not success then vim.notify("TSUpdate failed", vim.log.levels.ERROR) end
        end)

        local parsers = {
          "bash",
          "c",
          "comment",
          "css",
          "diff",
          "dockerfile",
          "git_config",
          "gitcommit",
          "gitignore",
          "go",
          "hcl",
          "html",
          "http",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "ssh_config",
          "sql",
          "typst",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        }

        for _, parser in ipairs(parsers) do
          local success = pcall(require("nvim-treesitter").install, parser)
          -- if not success then vim.notify("Treesitter parser install failed: " .. parser, vim.log.levels.ERROR) end
        end

        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        vim.api.nvim_command("set nofoldenable")

        vim.api.nvim_create_autocmd("FileType", {
          desc = "Start treesitter",
          group = group,
          pattern = parsers,
          callback = function() vim.treesitter.start() end,
        })
      end,
    },
  },
})
