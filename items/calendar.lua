local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_left = 1,
    padding_right = -1,
    font = {
      style = settings.font.style_map["Bold"],
      size = 10.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 15,
    width = 49,
    align = "right",
    font = { family = settings.font.numbers, size = 10 },
  },
  position = "right",
  update_freq = 2,
  padding_left = 1,
  padding_right = 0,
  background = {
    color = colors.transparent,
    border_color = colors.transparent,
    border_width = 1
  },
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = 30,
    border_color = colors.grey,
  }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = string.lower(os.date("%d %b")), label = os.date("%H:%M") })
end)
