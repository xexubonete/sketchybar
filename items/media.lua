local icons = require("icons")
local colors = require("colors")

-- Music widget (yellow)
local music_cover = sbar.add("item", {
  position = "right",
  background = {
    color = colors.yellow,
  },
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  updates = true,
  popup = {
    align = "center",
    horizontal = true,
  }
})

local music_artist = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    width = 0,
    font = { size = 7 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 18,
    y_offset = 7,
  },
})

local music_title = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = true },
  label = {
    font = { size = 9 },
    width = 0,
    max_chars = 16,
    y_offset = -3,
  },
})

-- Browser/Other widget (blue)
local other_cover = sbar.add("item", {
  position = "right",
  background = {
    color = colors.blue,
  },
  label = { drawing = false },
  icon = { drawing = false },
  drawing = false,
  updates = true,
  popup = {
    align = "center",
    horizontal = true,
  }
})

local other_artist = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  width = 0,
  icon = { drawing = false },
  label = {
    width = 0,
    font = { size = 7 },
    color = colors.with_alpha(colors.white, 0.6),
    max_chars = 18,
    y_offset = 7,
  },
})

local other_title = sbar.add("item", {
  position = "right",
  drawing = false,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = true },
  label = {
    font = { size = 9 },
    width = 0,
    max_chars = 16,
    y_offset = -3,
  },
})

-- Music controls
sbar.add("item", {
  position = "popup." .. music_cover.name,
  icon = { string = icons.media.back },
  label = { drawing = false },
  click_script = 'osascript -e \'tell application "Música" to previous track\'',
})
sbar.add("item", {
  position = "popup." .. music_cover.name,
  icon = { string = icons.media.play_pause },
  label = { drawing = false },
  click_script = 'osascript -e \'tell application "Música" to playpause\'',
})
sbar.add("item", {
  position = "popup." .. music_cover.name,
  icon = { string = icons.media.forward },
  label = { drawing = false },
  click_script = 'osascript -e \'tell application "Música" to next track\'',
})

local interrupt = { music = 0, other = 0 }

local function animate_music_detail(detail)
  if (not detail) then interrupt.music = interrupt.music - 1 end
  if interrupt.music > 0 and (not detail) then return end

  sbar.animate("tanh", 30, function()
    music_artist:set({ label = { width = detail and "dynamic" or 0 } })
    music_title:set({ label = { width = detail and "dynamic" or 0 } })
  end)
end

local function animate_other_detail(detail)
  if (not detail) then interrupt.other = interrupt.other - 1 end
  if interrupt.other > 0 and (not detail) then return end

  sbar.animate("tanh", 30, function()
    other_artist:set({ label = { width = detail and "dynamic" or 0 } })
    other_title:set({ label = { width = detail and "dynamic" or 0 } })
  end)
end

-- Music events
music_cover:subscribe("media_change", function(env)
  local app = env.INFO.app
  if not app or (app ~= "Música" and app ~= "Music") then return end  local drawing = (env.INFO.state == "playing")
  music_artist:set({ drawing = drawing, label = env.INFO.artist or app })
  music_title:set({ drawing = drawing, label = env.INFO.title or "Playing" })
  music_cover:set({ drawing = drawing })

  if drawing then
    animate_music_detail(true)
    interrupt.music = interrupt.music + 100
    sbar.delay(5, function() animate_music_detail(false) end)
  else
    music_cover:set({ popup = { drawing = false } })
  end
end)

-- Other media events
other_cover:subscribe("media_change", function(env)
  local app = env.INFO.app
  if not app or (app == "Música" or app == "Music") then return end
  local drawing = (env.INFO.state == "playing")
  other_artist:set({ drawing = drawing, label = env.INFO.artist or app })
  other_title:set({ drawing = drawing, label = env.INFO.title or "Playing" })
  other_cover:set({ drawing = drawing })

  if drawing then
    animate_other_detail(true)
    interrupt.other = interrupt.other + 100
    sbar.delay(5, function() animate_other_detail(false) end)
  else
    other_cover:set({ popup = { drawing = false } })
  end
end)

-- Mouse events for music
music_cover:subscribe("mouse.entered", function(env)
  interrupt.music = interrupt.music + 1
  animate_music_detail(true)
end)

music_cover:subscribe("mouse.exited", function(env)
  animate_music_detail(true)
end)

music_cover:subscribe("mouse.clicked", function(env)
  music_cover:set({ popup = { drawing = "toggle" }})
end)

music_title:subscribe("mouse.exited.global", function(env)
  music_cover:set({ popup = { drawing = false }})
end)

-- Mouse events for other media
other_cover:subscribe("mouse.entered", function(env)
  interrupt.other = interrupt.other + 1
  animate_other_detail(true)
end)

other_cover:subscribe("mouse.exited", function(env)
  animate_other_detail(true)
end)

other_cover:subscribe("mouse.clicked", function(env)
  other_cover:set({ popup = { drawing = "toggle" }})
end)

other_title:subscribe("mouse.exited.global", function(env)
  other_cover:set({ popup = { drawing = false }})
end)