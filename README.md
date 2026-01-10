# DiskTrend

A lightweight menu bar app for macOS that monitors disk space usage and predicts when your disk will be full.

## Features

- **Menu Bar Integration** - Lives in your menu bar with customizable display (icon, text, or both)
- **Multiple Icon Styles** - Choose from pie chart, battery, color dot, or vertical bar
- **Trend Analysis** - Tracks disk usage over time and calculates daily change rate
- **Forecast** - Predicts when your disk will be full based on usage trends
- **Historical Chart** - View disk space history for 7, 14, or 30 days with forecast visualization
- **Multiple Volumes** - Monitor all mounted volumes
- **Color-coded Status** - Green, yellow, orange, and red indicators based on free space
- **Customizable Alerts** - Set warning and critical thresholds
- **Dark Mode Support** - System, light, or dark appearance
- **Localization** - English and Finnish

## Requirements

- macOS 14.0 (Sonoma) or later
- Apple Silicon (arm64)

## Installation

Download the latest release from the [Releases](../../releases) page and drag DiskTrend.app to your Applications folder.

## Building from Source

### Prerequisites

- Xcode 16.0 or later
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (optional, for regenerating project)

### Build

1. Clone the repository:
   ```bash
   git clone https://github.com/tiltti/disktrend.git
   cd disktrend
   ```

2. Open in Xcode:
   ```bash
   open DiskTrend.xcodeproj
   ```

3. Build and run (Cmd+R)

### Regenerate Xcode Project

If you modify `project.yml`:
```bash
xcodegen generate
```

## Settings

### General
- **Appearance** - System, Light, or Dark mode
- **Display Mode** - Icon and text, icon only, or text only
- **Icon Style** - Pie chart, battery, color dot, or vertical bar
- **Chart Period** - 7, 14, or 30 days of history
- **Update Interval** - 10 seconds to 5 minutes
- **Decimal Places** - Number of decimals in percentage display
- **Launch at Login** - Start automatically when you log in

### Alerts
- **Warning Threshold** - When free space drops below this percentage, icon turns yellow
- **Critical Threshold** - When free space drops below this percentage, icon turns red

## License

MIT License
