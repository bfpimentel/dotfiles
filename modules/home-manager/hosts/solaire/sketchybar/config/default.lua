local settings = require("config.settings")

sbar.default({
  updates = "when_shown",
  icon = {
    color = settings.colors.white,
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.icon,
    },
    padding_left = 0,
    padding_right = 0,
  },
  label = {
    color = settings.colors.white,
    padding_left = 0,
    padding_right = 0,
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.regular,
      size = settings.dimens.text.label,
    },
  },
  background = {
    color = settings.colors.transparent,
    height = settings.dimens.graphics.background.height,
    padding_left = settings.dimens.padding.item,
    padding_right = settings.dimens.padding.item,
    border_width = 0,
  },
  popup = {
    y_offset = settings.dimens.padding.popup,
    align = "center",
    background = {
      corner_radius = settings.dimens.graphics.background.corner_radius,
      color = settings.colors.with_alpha(settings.colors.base, 0.5),
      border_color = settings.colors.surface0,
      border_width = 1,
      padding_left = settings.dimens.padding.icon,
      padding_right = settings.dimens.padding.icon,
    },
    blur_radius = settings.dimens.graphics.blur_radius,
  },
  slider = {
    highlight_color = settings.colors.lavender,
    background = {
      height = settings.dimens.graphics.slider.height,
      corner_radius = settings.dimens.graphics.background.corner_radius,
      color = settings.colors.with_alpha(settings.colors.base, 0.5),
      border_color = settings.colors.surface0,
      border_width = 1,
    },
    knob = {
      font = {
        family = settings.fonts.text,
        style = settings.fonts.styles.regular,
        size = 32,
      },
      string = settings.icons.text.slider.knob,
      drawing = false,
    },
  },
  scroll_texts = true,
})
