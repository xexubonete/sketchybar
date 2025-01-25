local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 250

local brightness_percent = sbar.add("item", "widgets.brightness1", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??%",
    padding_left = -1,
    font = { family = settings.font.numbers, size = 10}
  },
})

local brightness_icon = sbar.add("item", "widgets.brightness2", {
  position = "right",
  padding_right = -4,
  icon = {
    string = "",
    width = 0,
    align = "left",
    color = colors.transparent,
    font = {
      style = settings.font.style_map["Regular"],
    },
  },
  label = {
    string = icons.brightness,
    width = 25,
    align = "left",
    font = {
      style = settings.font.style_map["Regular"],
      size = 10.0,
    },
  },
})

local brightness_bracket = sbar.add("bracket", "widgets.brightness.bracket", {
  brightness_icon.name,
  brightness_percent.name
}, {
  background = { color = colors.transparent },
  popup = { align = "center" }
})

sbar.add("item", "widgets.brightness.padding", {
  position = "right",
  width = settings.group_paddings
})

local brightness_slider = sbar.add("slider", popup_width, {
  position = "popup." .. brightness_bracket.name,
  slider = {
    highlight_color = colors.blue,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob= {
      string = "􀀁",
      drawing = true,
    },
  },
  background = { color = colors.bg1, height = 2, y_offset = -20 },
  click_script = 'brightness $PERCENTAGE'
})

brightness_percent:subscribe("brightness_change", function(env)
  local brightness = tonumber(env.INFO)
  local lead = ""
  brightness_percent:set({ label = lead .. brightness .. "%" })
  brightness_slider:set({ slider = { percentage = brightness } })
end)

local function brightness_collapse_details()
  local drawing = brightness_bracket:query().popup.drawing == "on"
  if not drawing then return end
  brightness_bracket:set({ popup = { drawing = false } })
end

local function brightness_toggle_details(env)
  if env.BUTTON == "right" then
    sbar.exec("open /System/Library/PreferencePanes/Displays.prefPane")
    return
  end

  local should_draw = brightness_bracket:query().popup.drawing == "off"
  brightness_bracket:set({ popup = { drawing = should_draw } })
end

local function brightness_scroll(env)
  local delta = env.INFO.delta
  if not (env.INFO.modifier == "ctrl") then delta = delta * 10.0 end
  
  if delta > 0 then
    sbar.exec('brightness up')
  else
    sbar.exec('brightness down')
  end
end

brightness_icon:subscribe("mouse.clicked", brightness_toggle_details)
brightness_icon:subscribe("mouse.scrolled", brightness_scroll)
brightness_percent:subscribe("mouse.clicked", brightness_toggle_details)
brightness_percent:subscribe("mouse.exited.global", brightness_collapse_details)
brightness_percent:subscribe("mouse.scrolled", brightness_scroll) 