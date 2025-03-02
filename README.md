# Egg Timer

A simple iOS app built with SwiftUI that helps you cook the perfect egg—soft, medium, or hard. Just tap on the egg type, and the timer will count down to zero while displaying a friendly interface. When time is up, a built-in system sound will play to alert you.

(All PNG images and the app icon were drawn by me using Procreate.) 

## Features

- **SwiftUI** for a clean and modern user interface.
- **Three cooking times:** Soft (6 minutes), Medium (8 minutes), and Hard (12 minutes).
- **Visual countdown** with a large, easy-to-read timer display.
- **Reset button** to easily stop the timer and clear the countdown.
- **Alarm sound** using `AudioToolbox` when the countdown finishes.

## Folder Structure

```css
egg-timer/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   ├── Contents.json
│   ├── hard-boiled.imageset/
│   │   └── hard-boiled.png
│   ├── medium-boiled.imageset/
│   │   └── medium-boiled.png
│   ├── soft-boiled.imageset/
│   │   └── soft-boiled.png
├── ContentView.swift
├── egg_timerApp.swift
├── Preview Content/
├── egg-timer.xcodeproj/
├── egg-timerTests/
└── egg-timerUITests/
```

- `Assets.xcassets`: Contains the app icon and all egg images (drawn in Procreate).
- `ContentView.swift`: The main SwiftUI file where the user interface, timer logic, and alarm sound are handled.
- `egg_timerApp.swift`: The app entry point uses the SwiftUI `@main` app structure.
- `egg-timer.xcodeproj/`: Xcode project file.
- `egg-timerTests/` and `egg-timerUITests/`: Boilerplate test targets (currently empty).

## How It Works

1. Select Egg Type

Tap on either the Soft, Medium, or Hard egg image. The timer will start automatically at the corresponding time.

2. Watch the Countdown

The remaining time is displayed in the middle of the screen in minutes and seconds (mm:ss format).

3. Alarm

When the timer hits zero, a built-in system sound plays to alert you that your eggs are ready.

4. Reset

To stop the timer or start over, tap the **Reset** button.

## Code Highlights

- Timer Logic

```swift
let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()

// ...
.onReceive(timer) { _ in
    if timerIsRunning {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timerIsRunning = false
            playAlarmSound()
        }
    }
}
```

- Color from Hex

```swift
extension Color {
    init(hex: String) {
        // ...
    }
}
```

Simple utility for using hex color strings in SwiftUI.

- Audio Alert

```swift
private func playAlarmSound() {
    AudioServicesPlaySystemSound(1005)
}
```

Uses `AudioToolbox` to play a system sound when the timer reaches zero.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3 or higher

## Installation and Running

1. Clone the Repo

```bash
git clone https://github.com/your_username/egg-timer.git
```

2. Open in Xcode

Double-click on `egg-timer.xcodeproj`.

3. Build and Run

- Select an iOS Simulator or a real device.
- Hit the Run button in Xcode.

4. Tap an Egg

Choose your preferred doneness, and let the timer run!


Contributions and suggestions are welcome!











