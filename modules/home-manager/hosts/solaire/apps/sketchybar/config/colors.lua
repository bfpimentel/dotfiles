local Colors = {}

local everforest = {
  fg = 0xFFD3C6AA,
  red = 0xFFE67E80,
  orange = 0xFFE69875,
  yellow = 0xFFDBBC7F,
  green = 0xFFA7C080,
  aqua = 0xFF83C092,
  blue = 0xFF7FBBB3,
  purple = 0xFFD699B6,
  grey0 = 0xFF7A8478,
  grey1 = 0xFF859289,
  grey2 = 0xFF9DA9A0,
  statusline1 = 0xFFA7C080,
  statusline2 = 0xFFD3C6AA,
  statusline3 = 0xFFE67E80,
  bg_dim = 0xFF293136,
  bg0 = 0xFF333C43,
  bg1 = 0xFF3A464C,
  bg2 = 0xFF434F55,
  bg3 = 0xFF4D5960,
  bg4 = 0xFF555F66,
  bg5 = 0xFF5D6B66,
  bg_visual = 0xFF5C3F4F,
  bg_red = 0xFF59464C,
  bg_green = 0xFF48584E,
  bg_blue = 0xFF3F5865,
  bg_yellow = 0xFF55544A,
  bg_purple = 0xFF4e4953,
  bg_black = 0xFF000000,
}

Colors.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00FFFFFF) | (math.floor(alpha * 255.0) << 24)
end

Colors.sections = {
  -- Core Components
  bar = {
    bg = Colors.with_alpha(everforest.bg_black, 0.8),
    border = everforest.bg_dim,
  },
  item = {
    bg = Colors.with_alpha(everforest.bg0, 0.8),
    border = everforest.bg_dim,
    text = everforest.fg,
    shadow = Colors.with_alpha(everforest.bg_dim, 0.5),
  },
  popup = {
    bg = Colors.with_alpha(everforest.bg_black, 0.8),
    border = everforest.bg_dim,
  },

  -- Items
  apple = everforest.green,
  media = { label = everforest.fg },
  calendar = { label = everforest.fg },
  spaces = {
    bg = Colors.with_alpha(everforest.bg_black, 0.8),
    icon = {
      color = everforest.fg,
      highlight = everforest.yellow,
    },
    label = {
      color = everforest.fg,
      highlight = everforest.yellow,
    },
    indicator = everforest.blue,
  },
  widgets = {
    battery = {
      low = everforest.red,
      mid = everforest.yellow,
      high = everforest.green,
    },
    wifi = {
      icon = everforest.fg,
      active = everforest.green,
    },
    volume = {
      icon = everforest.blue,
      popup = {
        item = everforest.fg,
        highlight = everforest.orange,
        bg = Colors.with_alpha(everforest.bg_black, 0.8),
      },
      slider = {
        highlight = everforest.fg,
        border = everforest.bg1,
        bg = Colors.with_alpha(everforest.bg_black, 0.8),
      },
    },
    messages = { icon = everforest.red },
  },
}

return Colors
