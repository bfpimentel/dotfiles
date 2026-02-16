_B.pack.now_if_args(function()
  local ts_update = function() vim.cmd("TSUpdate") end
  _B.pack.on_changed("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  _B.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
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
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end

  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  _B.util.new_autocmd("Start tree-sitter", "FileType", filetypes, ts_start)
end)
