---@diagnostic disable: duplicate-doc-field, duplicate-set-field, duplicate-type

---@class Keymap
---@field [1] string lhs
---@field [2] string|function rhs
---@field opts? vim.keymap.set.Opts
---@field mode? string|string[]

---@class Keys : Keymap[]|(fun():Keymap[])

---@class Data
---@field keys? Keys
---@field load? fun():void

---@class PluginSpec : vim.pack.Spec
---@field data? Data

_B = {}

---@param keys Keys
function _B.map_keys(keys)
  local keysResult

  if type(keys) == "function" then
    keysResult = keys()
  else
    keysResult = keys
  end

  for _, item in ipairs(keysResult) do
    local lhs, rhs = item[1], item[2] or ""
    vim.keymap.set(item.mode or "n", lhs, rhs, item.opts)
  end
end

---@param plugins PluginSpec[]
function _B.add(plugins)
  vim.pack.add(plugins, {
    confirm = false,
    load = function(plugin)
      ---@type Data
      local data = plugin.spec.data or {}

      vim.cmd.packadd(plugin.spec.name)

      if data.load then data.load() end
      if data.keys then _B.map_keys(data.keys) end
    end,
  })
end
