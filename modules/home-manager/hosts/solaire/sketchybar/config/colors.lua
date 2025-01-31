local M = {}

local with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00FFFFFF) | (math.floor(alpha * 255.0) << 24)
end

local transparent = 0x00000000

local catppuccin = {
  rosewater = 0xFFF5E0DC,
  flamingo = 0xFFF2CDCD,
  pink = 0xFFF5C2E7,
  mauve = 0xFFCBA6F7,
  red = 0xFFF38BA8,
  maroon = 0xFFEBA0AC,
  peach = 0xFFFAB387,
  yellow = 0xFFF9E2AF,
  green = 0xFFA6E3A1,
  teal = 0xFF94E2D5,
  sky = 0xFF89DCEB,
  sapphire = 0xFF74C7EC,
  blue = 0xFF89B4FA,
  lavender = 0xFFB4BEFE,
  text = 0xFFCDD6F4,
  subtext1 = 0xFFBAC2DE,
  subtext0 = 0xFFA6ADC8,
  overlay2 = 0xFF9399B2,
  overlay1 = 0xFF7F849C,
  overlay0 = 0xFF6C7086,
  surface2 = 0xFF585B70,
  surface1 = 0xFF45475A,
  surface0 = 0xFF313244,
  base = 0xFF1E1E2E,
  mantle = 0xFF181825,
  crust = 0xFF11111B,
}

M.sections = {
  -- Core Components
  bar = {
    bg = with_alpha(catppuccin.base, 0.7),
    border = catppuccin.crust,
  },
  item = {
    bg = catppuccin.surface0,
    border = catppuccin.crust,
    text = catppuccin.text,
  },
  popup = {
    bg = with_alpha(catppuccin.base, 0.7),
    border = catppuccin.crust,
  },

  -- Items
  apple = catppuccin.flamingo,
  media = { label = catppuccin.text },
  calendar = { label = catppuccin.text },
  spaces = {
    icon = {
      color = catppuccin.subtext0,
      highlight = catppuccin.yellow,
    },
    label = {
      color = catppuccin.subtext0,
      highlight = catppuccin.yellow,
    },
    indicator = catppuccin.mauve,
  },
  widgets = {
    battery = {
      low = catppuccin.red,
      mid = catppuccin.yellow,
      high = catppuccin.green,
    },
    wifi = {
      icon = catppuccin.text,
    },
    volume = {
      icon = catppuccin.blue,
      popup = {
        item = catppuccin.text,
        highlight = catppuccin.subtext0,
        bg = with_alpha(catppuccin.base, 0.7),
      },
      slider = {
        highlight = catppuccin.text,
        bg = with_alpha(catppuccin.base, 0.7),
        border = catppuccin.surface0,
      },
    },
    messages = { icon = catppuccin.flamingo },
  },
}

return M
