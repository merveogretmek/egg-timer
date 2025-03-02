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
