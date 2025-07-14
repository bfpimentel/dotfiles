local colors = require("colors").sections.bar

sbar.bar {
  topmost = "window",
  height = 41,
  notch_display_height = 41,
  padding_right = 12,
  padding_left = 12,
  margin = -1,
  corner_radius = 0,
  y_offset = -1,
  blur_radius = 20,
  border_color = colors.border,
  border_width = 1,
  color = colors.bg,
}
