---@diagnostic disable: param-type-mismatch

---@class Keymap
---@field [1] string lhs
---@field [2] string|function rhs
---@field opts? vim.keymap.set.Opts
---@field mode? string|string[]

_G.Util = {}
_G.Pack = {}

---@param group_name string
function Util.patch_hl_with_transparency(group_name)
  local hl = vim.api.nvim_get_hl(0, { name = group_name })
  local patched_hl = vim.tbl_deep_extend("force", hl, { bg = "NONE" })
  vim.api.nvim_set_hl(0, group_name, patched_hl)
end

---@param keys Keymap[]
---@param default_opts? vim.keymap.set.Opts
function Util.map_keys(keys, default_opts)
  for _, item in ipairs(keys) do
    local lhs, rhs = item[1], item[2] or ""
    local opts = vim.tbl_deep_extend("force", item.opts or {}, default_opts or {})
    vim.keymap.set(item.mode or "n", lhs, rhs, opts)
  end
end

local group = vim.api.nvim_create_augroup("bfmp", {})
Util.new_autocmd = function(desc, event, pattern, callback)
  local opts = { group = group, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local MiniMisc = require("mini.misc")

Pack.add = vim.pack.add
Pack.now = function(callback) MiniMisc.safely("now", callback) end
Pack.later = function(callback) MiniMisc.safely("later", callback) end
Pack.now_if_args = vim.fn.argc(-1) > 0 and Pack.now or Pack.later
Pack.on_event = function(event, callback) MiniMisc.safely("event:" .. event, callback) end
Pack.on_filetype = function(filetype, callback) MiniMisc.safely("filetype:" .. filetype, callback) end

Pack.on_changed = function(plugin_name, kinds, callback, desc)
  local exec_on_changed = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not event.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end

  Util.new_autocmd(desc, "PackChanged", "*", exec_on_changed)
end
