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

local rp_moon = {
  base = 0xFF232136,
  surface = 0xFF2A273F,
  overlay = 0xFF393552,
  muted = 0xFF6E6A86,
  subtle = 0xFF908CAA,
  text = 0xFFE0DEF4,
  love = 0xFFEB6F92,
  rose = 0xFFEA9A97,
  gold = 0xFFF6C177,
  iris = 0xFFC4A7E7,
  pine = 0xFF3E8FB0,
  foam = 0xFF9CCFD8,
  highlight_low = 0xFF21202E,
  highlight_med = 0xFF44415A,
}

M.sections = {
  bar = {
    bg = with_alpha(catppuccin.base, 0.5),
    border = transparent,
  },
  item = {
    bg = catppuccin.surface0,
    border = catppuccin.crust,
    text = catppuccin.text,
  },
  apple = catppuccin.flamingo,
  spaces = {
    icon = {
      color = catppuccin.subtext0,
      highlight = catppuccin.yellow,
    },
    label = {
      color = catppuccin.subtext0,
      highlight = catppuccin.yellow,
    },
    indicator = rp_moon.iris,
  },
  media = {
    label = rp_moon.subtle,
  },
  widgets = {
    battery = {
      low = rp_moon.love,
      mid = rp_moon.gold,
      high = rp_moon.pine,
    },
    wifi = { icon = rp_moon.rose },
    volume = {
      icon = rp_moon.foam,
      popup = {
        item = rp_moon.subtle,
        highlight = rp_moon.text,
      },
      slider = {
        highlight = rp_moon.foam,
        bg = rp_moon.highlight_med,
        border = rp_moon.highlight_low,
      },
    },
    messages = { icon = rp_moon.love },
  },
  calendar = {
    label = rp_moon.subtle,
  },
}

return M
