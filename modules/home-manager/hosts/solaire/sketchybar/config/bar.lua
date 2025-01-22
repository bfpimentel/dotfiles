local settings = require("config.settings")

sbar.bar({
	topmost = "window",
	height = settings.dimens.graphics.bar.height,
	notch_display_height = settings.dimens.graphics.bar.notch_height,
	y_offset = settings.dimens.graphics.bar.y_offset,
	margin = settings.dimens.graphics.bar.margin,
	padding_right = settings.dimens.padding.bar,
	padding_left = settings.dimens.padding.bar,
	color = settings.colors.with_alpha(settings.colors.base, 0.5),
	border_color = settings.colors.overlay0,
	border_width = settings.dimens.graphics.bar.border_width,
	blur_radius = 20,
	font_smoothing = true,
})
