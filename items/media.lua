local icons = require("icons")
local colors = require("colors")

local item_width = 10 -- Ajusta este valor para que encaje bien en tu barra

-- Item para mostrar el artista (texto pequeño y gris)
local music_artist = sbar.add("item", "music_artist", {
  position = "right",
  drawing = false,
  width = item_width,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = 7 },
    color = colors.with_alpha(colors.white, 0.6),
    y_offset = 7,
    max_chars = 20,
    width = item_width,
  },
})

-- Item para mostrar el título (texto más grande y blanco)
local music_title = sbar.add("item", "music_title", {
  position = "right",
  drawing = false,
  width = item_width,
  padding_left = 3,
  padding_right = 0,
  icon = { drawing = false },
  label = {
    font = { size = 9 },
    color = colors.white,
    y_offset = -3,
    max_chars = 20,
    width = item_width,
  },
})

local interrupt = { music = 0 }

local function animate_music_detail(detail)
  if (not detail) then interrupt.music = interrupt.music - 1 end
  if interrupt.music > 0 and (not detail) then
    print("[DEBUG] Animation interrupted, skipping animation step")
    return
  end

  print("[DEBUG] Animating music detail, drawing:", tostring(detail))
  sbar.animate("tanh", 20, function()
    music_artist:set({ label = { width = detail and "dynamic" or 0 } })
    music_title:set({ label = { width = detail and "dynamic" or 0 } })
  end)
end

local function update_music()
  print("[DEBUG] update_music called")
  sbar.exec([[osascript -e 'tell application "Music"
try
  if player state is playing then
    set trackName to name of current track
    set artistName to artist of current track
    return "playing:" & artistName & ":" & trackName
  else
    return "not_playing"
  end if
on error
  return "not_playing"
end try
end tell']], function(result)
    if not result then
      print("[DEBUG] No result from osascript")
      return
    end
    local trimmed = result:gsub("\n", ""):gsub("\r", "")
    print("[DEBUG] Music state raw result: '" .. trimmed .. "'")

    if trimmed:match("^playing:") then
      local parts = {}
      for part in trimmed:gmatch("([^:]+)") do
        table.insert(parts, part)
      end

      local artist = parts[2] or "Unknown Artist"
      local title = parts[3] or "Unknown Title"

      print(string.format("[DEBUG] Music playing - Artist: '%s', Title: '%s'", artist, title))

      music_artist:set({ drawing = true, label = artist })
      music_title:set({ drawing = true, label = title })

      animate_music_detail(true)
      interrupt.music = interrupt.music + 100
      sbar.delay(5, function() animate_music_detail(false) end)
    else
      print("[DEBUG] Music not playing - hiding widget")
      music_artist:set({ drawing = false })
      music_title:set({ drawing = false })
    end
  end)
end

local function music_timer()
  update_music()
  sbar.delay(0.5, music_timer)
end

-- Inicia el timer recursivo
music_timer()
