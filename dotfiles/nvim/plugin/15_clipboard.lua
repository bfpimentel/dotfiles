vim.o.clipboard = "unnamedplus"

if vim.env.SSH_TTY then
  local cache = {
    ["+"] = { {}, "v" },
    ["*"] = { {}, "v" },
  }

  local function set_cache(reg, lines, regtype) cache[reg] = { vim.deepcopy(lines), regtype } end

  local function get_cache(reg)
    local value = cache[reg] or { {}, "v" }
    return { vim.deepcopy(value[1]), value[2] }
  end

  local osc52 = require("vim.ui.clipboard.osc52")

  local function copy(reg)
    local osc_copy = osc52.copy(reg)
    return function(lines, regtype)
      set_cache(reg, lines, regtype)
      osc_copy(lines)
    end
  end

  local function paste(reg)
    return function() return get_cache(reg) end
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = copy("+"),
      ["*"] = copy("*"),
    },
    paste = {
      ["+"] = paste("+"),
      ["*"] = paste("*"),
    },
  }
end
