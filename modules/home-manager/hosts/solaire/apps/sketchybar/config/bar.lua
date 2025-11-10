local colors = require("colors").sections.bar

Sbar.bar({
  topmost = "window",
  height = 32,
  notch_display_height = 40,
  padding_right = 4,
  padding_left = 4,
  margin = -1,
  corner_radius = 0,
  y_offset = -1,
  blur_radius = 20,
  border_color = colors.border,
  border_width = 1,
  color = colors.bg,
})
