vim.wo.relativenumber = false
vim.wo.statuscolumn = ""
vim.wo.signcolumn = "no"

local orig_buf = vim.api.nvim_get_current_buf()
local lines = vim.api.nvim_buf_get_lines(orig_buf, 0, -1, false)

while #lines > 0 and vim.trim(lines[#lines]) == "" do
  lines[#lines] = nil
end

local buf = vim.api.nvim_create_buf(false, true)
local channel = vim.api.nvim_open_term(buf, {})

vim.api.nvim_chan_send(channel, table.concat(lines, "\r\n"))
vim.api.nvim_set_current_buf(buf)
vim.keymap.set("n", "q", "<cmd>qa!<cr>", { silent = true, buffer = buf })
vim.api.nvim_create_autocmd("TermEnter", { buffer = buf, command = "stopinsert" })
vim.defer_fn(function() vim.cmd.startinsert() end, 10)

vim.keymap.set("n", "q", "<cmd>qa!<CR>", { buffer = buf })
