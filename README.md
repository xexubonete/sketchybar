# Sketchybar

A custom configuration for [SketchyBar](https://github.com/FelixKratz/SketchyBar) using Lua as the configuration language.

## 🚀 Description

This project is a fork of SketchyBar, a highly customizable status bar for macOS, that implements configuration using Lua instead of the traditional shell script format. This approach allows for a more structured and maintainable configuration.

## ✨ Features

- Lua-based configuration
- Modular helper system
- Easy status bar customization 
- macOS system integration

## 📋 Prerequisites

- macOS
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) installed
- Lua

## 🛠️ Installation

1. Clone this repository:

```bash
git clone https://github.com/xexubonete/sketchybar.git
```

2. Ensure you have SketchyBar installed:

```bash
brew install sketchybar
```
3. Copy the configuration files:

```bash
cp -r sketchybar-lua/src ~/.config/sketchybar
```

// ... existing code ...

## 📁 Project Structure
├── README.md
├── bar.lua
├── colors.lua
├── default.lua
├── helpers
│   ├── app_icons.lua
│   ├── default_font.lua
│   ├── event_providers
│   │   ├── cpu_load
│   │   │   ├── bin
│   │   │   │   └── cpu_load
│   │   │   ├── cpu.h
│   │   │   ├── cpu_load.c
│   │   │   └── makefile
│   │   ├── makefile
│   │   ├── network_load
│   │   │   ├── bin
│   │   │   │   └── network_load
│   │   │   ├── makefile
│   │   │   ├── network.h
│   │   │   └── network_load.c
│   │   └── sketchybar.h
│   ├── init.lua
│   ├── makefile
│   └── menus
│       ├── bin
│       │   └── menus
│       ├── makefile
│       └── menus.c
├── icons.lua
├── init.lua
├── items
│   ├── apple.lua
│   ├── calendar.lua
│   ├── front_app.lua
│   ├── init.lua
│   ├── media.lua
│   ├── menus.lua
│   ├── spaces.lua
│   └── widgets
│       ├── battery.lua
│       ├── cpu.lua
│       ├── disk_stats.lua
│       ├── init.lua
│       ├── volume.lua
│       └── wifi.lua
├── settings.lua
└── sketchybarrc

## 🔧 Customization

You can customize your bar by modifying the Lua configuration files. The main `sketchybarrc` file loads the helpers and initial configuration.

## 🤝 Contributing

Contributions are welcome. Please open an issue or pull request to suggest changes or improvements.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [FelixKratz](https://github.com/FelixKratz) for creating SketchyBar