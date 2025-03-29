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
}
