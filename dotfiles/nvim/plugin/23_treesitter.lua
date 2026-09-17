Pack.later(function()
  local ts_update = function() vim.cmd("TSUpdate") end
  Pack.on_changed("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

  Pack.add(
    { "https://github.com/nvim-treesitter/nvim-treesitter" },
    { "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" }
  )

  local languages = {
    "bash",
    "c",
    "comment",
    "css",
    "dart",
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
    "jsx",
    "lua",
    "luadoc",
    "make",
    "nix",
    "python",
    "qmljs",
    "regex",
    "sql",
    "ssh_config",
    "tmux",
    "toml",
    "tsx",
    "typescript",
    "typst",
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
  Util.new_autocmd("Start tree-sitter", "FileType", filetypes, ts_start)
end)
