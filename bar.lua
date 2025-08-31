local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 22,
  color = colors.bar.trasparent, -- color exacto proporcionado por el usuario
  blur_radius = 5,      -- desenfoque para efecto visual estándar
  padding_right = 0,
  padding_left = 0,
  y_offset = -2,          -- centrado vertical
  position = "top",
})
