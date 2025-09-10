local colors = require("colors")
local settings = require("settings")

sbar.bar({
  height = 22,
  -- Usar un color semitransparente: si el color es totalmente transparente el blur no se mostrará
  color = colors.with_alpha(colors.macos_bar_dark, 0.65),
  -- blur_radius = math.floor(5 * settings.scale),      -- desenfoque para efecto visual estándar
  blur_radius = 55,      -- desenfoque para efecto visual estándar
  padding_right = 0,
  padding_left = 0,
  y_offset = -2,          -- centrado vertical
  position = "top",
})
