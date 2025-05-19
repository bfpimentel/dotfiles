return {
  "snacks.nvim",
  opts = {
    styles = {
      notification = {
        border = "single",
        zindex = 100,
        ft = "markdown",
        wo = {
          winblend = 5,
          wrap = true,
          conceallevel = 2,
          colorcolumn = "",
        },
        bo = { filetype = "snacks_notif" },
      }
    }
  }
}
