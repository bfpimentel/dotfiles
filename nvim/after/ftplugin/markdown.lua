vim.cmd("setlocal spell wrap")

vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")

vim.keymap.del("n", "gO", { buffer = 0 })

vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}
