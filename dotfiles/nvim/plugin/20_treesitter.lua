Pack.now_if_args(function()
  Pack.on_changed("nvim-treesitter", { "update" }, function() vim.cmd("TSUpdate") end, "Update Treesitter")

  Pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  })

  local languages = {
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
    "tmux",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  }

  local is_not_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  local to_install = vim.tbl_filter(is_not_installed, languages)
  if #to_install > 0 then pcall(require("nvim-treesitter").install, to_install) end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  local ts_start = function(event) vim.treesitter.start(event.buf) end
  Util.new_autocmd("Start tree-sitter", "FileType", filetypes, ts_start)
end)
