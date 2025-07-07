local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local dnd_icon = sbar.add("item", "widgets.dnd", {
  position = "right",
  padding_right = -4,
  icon = {
    string = "󰽥",
    width = 25,
    align = "left",
    color = colors.white,
    font = {
      style = settings.font.style_map["Regular"],
      size = 10.0,
    },
  },
  drawing = false,  -- Start with icon hidden
  label = { drawing = false },
})

local dnd_bracket = sbar.add("bracket", "widgets.dnd.bracket", {
  dnd_icon.name,
}, {
  background = { color = colors.transparent },
})

sbar.add("item", "widgets.dnd.padding", {
  position = "right",
  width = settings.group_paddings
})

dnd_icon:subscribe({"routine", "system_woke"}, function()
  sbar.exec([[
    if [ "$(defaults read com.apple.controlcenter 'NSStatusItem Visible FocusModes')" = "1" ]; then
      echo "active"
    else
      echo "inactive"
    fi
  ]], function(status)
    local is_active = status:match("active") ~= nil
    
    dnd_icon:set({
      drawing = is_active
    })
  end)
end)