local K = {}

function K.map(comb, action, opts) vim.keymap.set("n", "<Leader>" .. comb, action, opts) end

return K
