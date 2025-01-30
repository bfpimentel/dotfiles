return {
	{
		"echasnovski/mini.surround",
		lazy = false,
		version = false,
		opts = {},
	},
	{
		"echasnovski/mini.indentscope",
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
		"echasnovski/mini-git",
		main = "mini.git",
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
		"echasnovski/mini.hipatterns",
		lazy = false,
		version = false,
		opts = function()
			local hipatterns = require("mini.hipatterns")

			local extmark_opts_inline = function(_, _, data)
				return {
					virt_text = { { ' ', data.hl_group } },
					virt_text_pos = 'inline',
					priority = 200,
					right_gravity = false,
				}
			end

			-- "0xFFEACDTE"
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
					fixme      = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
					hack       = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
					todo       = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
					note       = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
					hex_color  = hipatterns.gen_highlighter.hex_color({ style = "inline", inline_text = " " }),
					argb_color = {
						pattern = "0x%x+",
						group = argb_color,
						extmark_opts = extmark_opts_inline,
					},
				}
			}
		end
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
		"echasnovski/mini.notify",
		lazy = false,
		version = false,
		opts = {
			window = {
				config = function()
					local has_statusline = vim.o.laststatus > 0
					local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
					return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
				end,
			},
		},
	},
	{
		"echasnovski/mini.base16",
		lazy = false,
		version = false,
		enabled = false,
		opts = {
			palette = {
				base00 = "#24283b",
				base01 = "#1f2335",
				base02 = "#292e42",
				base03 = "#565f89",
				base04 = "#a9b1d6",
				base05 = "#c0caf5",
				base06 = "#c0caf5",
				base07 = "#c0caf5",
				base08 = "#f7768e",
				base09 = "#ff9e64",
				base0A = "#e0af68",
				base0B = "#9ece6a",
				base0C = "#1abc9c",
				base0D = "#41a6b5",
				base0E = "#bb9af7",
				base0F = "#ff007c",
			},
		},
	},
}
