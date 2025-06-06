return {
  "esmuellert/nvim-eslint",
  lazy = false,
  opts = function()
    local eslint = require("nvim-eslint")
    local blink = require("blink.cmp")

    local capabilities = eslint.make_client_capabilities()
    capabilities = blink.get_lsp_capabilities(capabilities)

    return {
      capabilities = capabilities,
      settings = {
        useFlatConfig = true,
        workingDirectory = { mode = "location" },
      },
    }
  end,
}
