---
name: verify
description: Build, launch, and drive the ndsl app on the iOS simulator to verify changes end-to-end.
---

# Verifying ndsl on the iOS simulator

## Build & launch

```bash
xcrun simctl boot <UDID>            # pick one from: xcrun simctl list devices available
open -a Simulator --args -CurrentDeviceUDID <UDID>
flutter run -d <UDID>               # run in background; ready when "Flutter run key commands" appears
```

Bundle id: `com.example.ndsl`. Cold restart: `xcrun simctl terminate booted com.example.ndsl && xcrun simctl launch booted com.example.ndsl`.

## Screenshots (device-level, always works)

```bash
xcrun simctl io booted screenshot out.png    # 1206x2622 px = 402x874 pt (@3x) on iPhone 17
```

## Driving taps/typing (cliclick + accessibility geometry)

`screencapture` lacks permission in this environment; use the accessibility tree instead:

```bash
osascript -e 'tell application "System Events" to tell process "Simulator" to get {role, position, size} of every UI element of window 1'
```

The `AXGroup` child is the device screen (e.g. pos 564,117 size 383x832). Map device points → Mac screen: `screen = group_origin + pt * (group_size / device_pt_size)` (scale ~0.95).

```bash
cliclick c:X,Y                      # tap
cliclick dd:X,Y w:1000 du:X,Y       # long-press (Flutter threshold 500ms)
cliclick t:'some text'              # type into focused field
```

## Gotchas

- Activate Simulator first (`osascript -e 'tell application "Simulator" to activate'`) — cliclick posts to whatever is frontmost.
- Typing via cliclick = hardware keyboard: the software keyboard dismisses and dialogs re-center — re-locate buttons after typing.
- Simulator.app can quit while the device keeps running headless (flutter run stays alive). Reopen with `open -a Simulator --args -CurrentDeviceUDID <UDID>` and re-read window geometry.
- `dart run build_runner build` needs `--force-jit` (AOT builder compile fails on sqlite3 native-asset hooks).
