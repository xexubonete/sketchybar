local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Bold"],
      size = 12,
    },
    padding_right = -1
  },
  label = { font = { family = settings.font.numbers, size = 10 } },
  update_freq = 2,
  popup = { align = "center" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = 100,
    align = "left"
  },
  label = {
    string = "??:??h",
    width = 100,
    align = "right"
  },
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    sbar.exec("pmset -g | grep lowpowermode", function(lpm_info)
      local icon = "!"
      local label = "?"

      local found, _, charge = batt_info:find("(%d+)%%")
      if found then
        charge = tonumber(charge)
        label = charge .. "%"
      end

      local color = colors.green
      local charging, _, _ = batt_info:find("AC Power")

      local low_power = lpm_info:find("1")
      if low_power then
        color = colors.yellow
        label = label
      end

      if charging then
        icon = icons.battery.charging
      else
        if found and charge > 79 then
          icon = icons.battery._100
        elseif found and charge > 59 then
          icon = icons.battery._75
        elseif found and charge > 29 then
          icon = icons.battery._50
        elseif found and charge > 9 then
          icon = icons.battery._25
        elseif found and charge > 0 then
          icon = icons.battery._0
          color = colors.red
        else
          icon = icons.battery._0
          color = colors.red
        end
      end

      local lead = ""
      if found and charge < 10 then
        --lead = "0"
      end

      battery:set({
        icon = {
          string = icon,
          color = color
        },
        label = { string = lead .. label },
      })
    end)
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set( { popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set( { label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { color = colors.transparent }
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.group_paddings,
})
