local P = require("utils.pack")

function setup_treesitter()
  local group = vim.api.nvim_create_augroup("bfmp.treesitter", { clear = true })

  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  local ensure_installed = {
    "c",
    "lua",
    "nix",
    "vim",
    "vimdoc",
    "python",
    "javascript",
    "typescript",
    "html",
    "css",
    "json",
    "yaml",
    "markdown",
    "markdown_inline",
  }

  local is_not_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  local to_install = vim.tbl_filter(is_not_installed, ensure_installed)
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end

  local filetypes = {}
  for _, lang in ipairs(ensure_installed) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Start treesitter",
    group = group,
    pattern = filetypes,
    callback = ts_start,
  })
end

P.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    data = {
      init = function(_)
        setup_treesitter()

        require("nvim-treesitter").setup()
      end,
    },
  },
})
