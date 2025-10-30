---@diagnostic disable: duplicate-doc-field

local P = {}

local group = vim.api.nvim_create_augroup("PackPlugins", { clear = true })

---@class Lazy
---@field ft? string[]
---@field event? string
---@field cmd? string
---@field keys? Keys

---@class Keys
---@field [1] string lhs
---@field [2]? string|function rhs
---@field mode? string
---@field opts? vim.keymap.set.Opts

---@class Data
---@field lazy? Lazy
---@field keys? Keys[]|fun():Keys[]
---@field init? fun(plugin: vim.pack.Spec)

---@class PluginSpec: vim.pack.Spec
---@field data? Data

---@param keys Keys[]|fun():Keys[]
local function map_keys(keys)
  local keysResult = type(keys) == "function" and keys() or keys --[=[@as Keys[]]=]
  for _, item in ipairs(keysResult) do
    local lhs, rhs = item[1], item[2] or ""
    vim.keymap.set(item.mode or "n", lhs, rhs, item.opts)
  end
end

---@param ft string[]
---@param load_plugin function
local function add_ft_lazyload(ft, load_plugin)
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    once = true,
    pattern = ft,
    callback = load_plugin,
  })
end

---@param event string
---@param load_plugin function
local function add_event_lazyload(event, load_plugin)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    once = true,
    pattern = "*",
    callback = load_plugin,
  })
end

---@param trigger Keys
---@param load_plugin function
local function add_keys_lazyload(trigger, load_plugin)
  local lhs, mode = trigger[1], trigger.mode or "n"

  vim.keymap.set(mode, lhs, function()
    vim.keymap.del(mode, lhs)
    load_plugin()
    vim.api.nvim_feedkeys(vim.keycode(lhs), "m", false)
  end, trigger.opts)
end

---@param cmd string
---@param load_plugin function
local function add_cmd_lazyload(cmd, load_plugin)
  vim.api.nvim_create_user_command(cmd, function(cmd_args)
    pcall(vim.api.nvim_del_user_command, cmd)
    load_plugin()
    vim.api.nvim_cmd({
      cmd = cmd,
      args = cmd_args.fargs,
      bang = cmd_args.bang,
      nargs = cmd_args.nargs,
      range = cmd_args.range ~= 0 and { cmd_args.line1, cmd_args.line2 } or nil,
      count = cmd_args.count ~= -1 and cmd_args.count or nil,
    }, {})
  end, {})
end

---@param plugins PluginSpec[]
function P.add(plugins)
  vim.pack.add(plugins, {
    load = function(plugin)
      local data = plugin.spec.data or {}
      local lazy = data.lazy or {} --[[@as Lazy]]

      local function load_plugin()
        vim.cmd.packadd(plugin.spec.name)
        if data.init then data.init(plugin) end
        if data.keys then map_keys(data.keys) end
      end

      if lazy.keys then
        add_keys_lazyload(lazy.keys, load_plugin)
      elseif lazy.ft then
        add_ft_lazyload(lazy.ft, load_plugin)
      elseif lazy.event then
        add_event_lazyload(lazy.event, load_plugin)
      elseif lazy.cmd then
        add_cmd_lazyload(lazy.cmd, load_plugin)
      else
        load_plugin()
      end
    end,
  })
end

return P
