return {
  {
    "echasnovski/mini.surround",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.diff",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    lazy = false,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.move",
    lazy = false,
    version = false,
    opts = {
      options = { reindent_linewise = true },
      mappings = {
        -- Visual mode
        left = "",
        right = "",
        down = "<C-S-j>",
        up = "<C-S-k>",

        -- Normal mode
        line_left = "",
        line_right = "",
        line_down = "<C-S-j>",
        line_up = "<C-S-k>",
      },
    },
  },
  {
    "echasnovski/mini.icons",
    lazy = false,
    version = false,
    specs = { { "nvim-tree/nvim-web-devicons", enabled = false, optional = true } },
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.files",
    lazy = false,
    version = false,
    opts = {},
    keys = {
      {
        "<leader>e",
        function()
          local MiniFiles = require("mini.files")
          local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          vim.defer_fn(function()
            MiniFiles.reveal_cwd()
          end, 30)
        end,
        desc = "File Explorer",
      },
    },
  },
  {
    "echasnovski/mini.hipatterns",
    lazy = false,
    version = false,
    opts = function()
      local MiniHipatterns = require("mini.hipatterns")

      local extmark_opts_inline = function(_, _, data)
        return {
          virt_text = { { " ", data.hl_group } },
          virt_text_pos = "inline",
          priority = 200,
          right_gravity = false,
        }
      end

      -- "0xEACDTE"
      -- #00EACDTE
      local argb_color = function(_, match)
        if string.len(match) ~= 10 then
          return false
        else
          local hex = string.format("#%s", match:sub(5, 10))
          return MiniHipatterns.compute_hex_color_group(hex, "fg")
        end
      end

      return {
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          hex_color = MiniHipatterns.gen_highlighter.hex_color({ style = "inline", inline_text = " " }),
          argb_color = {
            pattern = "0x%x+",
            group = argb_color,
            extmark_opts = extmark_opts_inline,
          },
        },
      }
    end,
  },
  {
    "echasnovski/mini.statusline",
    lazy = false,
    version = false,
    init = function()
      vim.cmd([[set cmdheight=0]])
    end,
    opts = function()
      local MiniStatusline = require("mini.statusline")

      local function groups()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 40 })
        local diff = MiniStatusline.section_diff({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
        local filename = vim.fn.expand("%:.")
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })
        local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
          "%<", -- Mark general truncate point
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
          { hl = mode_hl, strings = { search ~= "" and " " .. search, " " .. location } },
        })
      end

      return {
        content = {
          active = groups,
          inactive = nil,
        },
      }
    end,
  },
}
