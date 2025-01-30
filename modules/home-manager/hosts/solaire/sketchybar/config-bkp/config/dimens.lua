local padding = {
  background = 8,
  icon = 8,
  label = 8,
  bar = 12,
  item = 8,
  popup = 12,
}

local graphics = {
  bar = {
    height = 32,
    notch_height = 41,
    y_offset = -1,
    margin = -1,
    border_width = 1,
  },
  background = {
    height = 24,
    corner_radius = 8,
  },
  slider = {
    height = 20,
  },
  popup = {
    width = 200,
    large_width = 300,
  },
  blur_radius = 30,
}

local text = {
  icon = 14.0,
  label = 12.0,
}

return {
  padding = padding,
  graphics = graphics,
  text = text,
}
