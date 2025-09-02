local colors = require("colors")
local settings = require("settings")

sbar.bar({
  height = math.floor(22 * settings.scale),
  -- Usar un color semitransparente: si el color es totalmente transparente el blur no se mostrará
  color = colors.with_alpha(colors.macos_bar_dark, 0.35),
  -- blur_radius = math.floor(5 * settings.scale),      -- desenfoque para efecto visual estándar
  blur_radius = 0,      -- desenfoque para efecto visual estándar
  padding_right = 0,
  padding_left = 0,
  y_offset = math.floor(-2 * settings.scale),          -- centrado vertical
  position = "top",
})
