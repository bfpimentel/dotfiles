---@diagnostic disable: duplicate-doc-field
---@diagnostic disable: duplicate-set-field

---@class Keys
---@field [1] string lhs
---@field [2]? string|function rhs
---@field [3]? vim.keymap.set.Opts opts
---@field mode? string|string[]

---@class Data
---@field keys? Keys[]|fun():Keys[]
---@field init? fun(plugin: vim.pack.Spec)

---@class PluginSpec: vim.pack.Spec
---@field data? Data

_B = {}

---@param keys Keys[]|fun():Keys[]
function _B.map_keys(keys)
  local keysResult = type(keys) == "function" and keys() or keys --[=[@as Keys[]]=]
  for _, item in ipairs(keysResult) do
    local lhs, rhs, opts = item[1], item[2] or "", item[3] or {}
    vim.keymap.set(item.mode or "n", lhs, rhs, opts)
  end
end

---@param plugins PluginSpec[]
function _B.add(plugins)
  vim.pack.add(plugins, {
    load = function(plugin)
      local data = plugin.spec.data or {}

      vim.cmd.packadd(plugin.spec.name)
      if data.init then data.init(plugin) end
      if data.keys then _B.map_keys(data.keys) end
    end,
  })
end
