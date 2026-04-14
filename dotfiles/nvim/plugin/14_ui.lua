Util.new_autocmd("Message Location", "Filetype", "msg", function()
  local ui2 = require("vim._core.ui2")
  local win = ui2.wins and ui2.wins.msg
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_option_value(
      "winhighlight",
      "Normal:NormalFloat,FloatBorder:FloatBorder",
      { scope = "local", win = win }
    )
  end
end)

Util.new_autocmd("LSP Progress popup", "LspProgress", nil, function(event)
  local value = event.data.params.value
  vim.api.nvim_echo({ { value.message or "done" } }, false, {
    id = "lsp." .. event.data.client_id,
    kind = "progress",
    source = "vim.lsp",
    title = value.title,
    status = value.kind ~= "end" and "running" or "success",
    percent = value.percentage,
  })
end)

Pack.later(function()
  local ui2 = require("vim._core.ui2")

  ui2.enable({
    enable = true,
    msg = {
      targets = {
        [""] = "msg",
        empty = "cmd",
        bufwrite = "msg",
        confirm = "cmd",
        emsg = "pager",
        echo = "msg",
        echomsg = "msg",
        echoerr = "pager",
        completion = "cmd",
        list_cmd = "pager",
        lua_error = "pager",
        lua_print = "msg",
        progress = "pager",
        rpc_error = "pager",
        quickfix = "msg",
        search_cmd = "cmd",
        search_count = "cmd",
        shell_cmd = "pager",
        shell_err = "pager",
        shell_out = "pager",
        shell_ret = "msg",
        undo = "msg",
        verbose = "pager",
        wildlist = "cmd",
        wmsg = "msg",
        typed_cmd = "cmd",
      },
      cmd = {
        height = 0.5,
      },
      dialog = {
        height = 0.5,
      },
      msg = {
        height = 0.3,
        timeout = 5000,
      },
      pager = {
        height = 0.5,
      },
    },
  })

  local msgs = require("vim._core.ui2.messages")
  local orig_set_pos = msgs.set_pos
  msgs.set_pos = function(target)
    orig_set_pos(target)
    if (target == "msg" or target == nil) and vim.api.nvim_win_is_valid(ui2.wins.msg) then
      pcall(vim.api.nvim_win_set_config, ui2.wins.msg, {
        relative = "editor",
        anchor = "NE",
        row = 1,
        col = vim.o.columns - 1,
        border = "single",
      })
    end
  end
end)

local function get_cmd_type()
  local ok, cmd_type = pcall(vim.fn.getcmdtype)
  return ok and cmd_type or ""
end

local function get_cmd_context(cmd_type, cmd_line)
  if cmd_type ~= ":" then return cmd_type end

  if cmd_line:match("^g%s*[^%s]+%s*s[/#|:]") then return "global_replace" end
  if cmd_line:match("^%%s") or cmd_line:match("^s[/#|:]") then return "replace" end
  if cmd_line:match("^%%!") or cmd_line:match("^!") then return "filter" end

  return cmd_type
end

local function get_cmd_title(context)
  local cmd_title = {
    [":"] = "Command (:)",
    ["/"] = "Search (/)",
    ["?"] = "Search (?)",
    replace = "Replace",
    global_replace = "Global Replace",
    filter = "Filter",
    default = "",
  }

  return cmd_title[context] or cmd_title.default
end

local function get_cmd_hl(context)
  local cmdline_border_hls = {
    [":"] = "Yellow",
    ["/"] = "Green",
    ["?"] = "Green",
    replace = "Orange",
    global_replace = "Orange",
    filter = "Blue",
    default = "FloatBorder",
  }

  return cmdline_border_hls[context] or cmdline_border_hls.default
end

local function update_cmdline_window()
  local ui2 = require("vim._core.ui2")
  local win = ui2.wins and ui2.wins.cmd

  if not (win and vim.api.nvim_win_is_valid(win)) then return end

  local cmd_type = get_cmd_type()
  local cmd_line = vim.fn.getcmdline()
  local cmd_context = get_cmd_context(cmd_type, cmd_line)
  local cmd_hl = get_cmd_hl(cmd_context)

  local width = math.floor(vim.o.columns * 0.5)

  pcall(
    vim.api.nvim_set_option_value,
    "winhighlight",
    ("Normal:NormalFloat,FloatBorder:%s,FloatTitle:%s"):format(cmd_hl, cmd_hl),
    { scope = "local", win = win }
  )

  pcall(vim.api.nvim_win_set_config, win, {
    title = (" %s "):format(get_cmd_title(cmd_context)),
    relative = "editor",
    row = (vim.o.lines / 2) - 1,
    col = (vim.o.columns - width) / 2,
    width = width,
    height = 1,
    anchor = "SW",
    border = "single",
    style = "minimal",
  })
end

Util.new_autocmd("Floating command line", "FileType", "cmd", update_cmdline_window)
Util.new_autocmd("Floating command line: Enter", "CmdlineEnter", nil, update_cmdline_window)
Util.new_autocmd("Floating command line: Update", "CmdlineChanged", nil, update_cmdline_window)
