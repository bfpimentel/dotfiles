---@diagnostic disable: param-type-mismatch

---@class Keymap
---@field [1] string lhs
---@field [2] string|function rhs
---@field opts? vim.keymap.set.Opts
---@field mode? string|string[]

_B = { util = {}, pack = {} }

---@param group_name string
function _B.util.patch_hl_with_transparency(group_name)
  local hl = vim.api.nvim_get_hl(0, { name = group_name })
  local patched_hl = vim.tbl_deep_extend("force", hl, { bg = "NONE" })
  vim.api.nvim_set_hl(0, group_name, patched_hl)
end

---@param keys Keymap[]
function _B.util.map_keys(keys)
  for _, item in ipairs(keys) do
    local lhs, rhs = item[1], item[2] or ""
    vim.keymap.set(item.mode or "n", lhs, rhs, item.opts)
  end
end

local group = vim.api.nvim_create_augroup("bfmp", {})
_B.util.new_autocmd = function(desc, event, pattern, callback)
  local opts = { group = group, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local MiniMisc = require("mini.misc")

_B.pack.add = function(spec) vim.pack.add(spec) end
_B.pack.now = function(callback) MiniMisc.safely("now", callback) end
_B.pack.later = function(callback) MiniMisc.safely("later", callback) end
_B.pack.now_if_args = vim.fn.argc(-1) > 0 and _B.pack.now or _B.pack.later
_B.pack.on_event = function(event, callback) MiniMisc.safely("event:" .. event, callback) end
_B.pack.on_filetype = function(ft, callback) MiniMisc.safely("filetype:" .. ft, callback) end

_B.pack.on_changed = function(plugin_name, kinds, callback, desc)
  local exec_on_changed = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not event.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end

  _B.util.new_autocmd(desc, "PackChanged", "*", exec_on_changed)
end
