# iPeak

Status: paused. The main work is from 2022; a small fix landed in 2026.

iPeak is a macOS network utility: local IP details, a speed test, and torrent lookup views. SwiftUI, Core Data, macOS 12.1 or later. Public repository, MIT.

## Commands

| Task | Command |
|------|---------|
| Build | `xcodebuild -project iPeak.xcodeproj -scheme iPeak build` |
| Test | `xcodebuild -project iPeak.xcodeproj -scheme iPeak test` |

## Layout

| Part | Role |
|------|------|
| `iPeak/ViewModels/` | `iPeakVM` (network data) and `TorrentDetailVM` |
| `iPeak/Views/` | Sidebar, local IP, speed test, and torrent detail views |
| `iPeak/Classes/Persistence.swift` | Core Data stack for `iPeak.xcdatamodeld` |

## Rules

- Keep the README feature list in step with the features that work.
