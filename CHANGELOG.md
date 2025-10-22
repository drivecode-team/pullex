# Changelog

## 1.0.1 – 2025-10-22

### Maintenance & Improvements
- Fixed missing and incorrect translations in built-in localizations.
- Renamed **`PullexRefreshController` → `RefreshController`** for a cleaner API.
- Updated deprecated Dart syntax (`typedef`, default parameter colons, `withOpacity`, and `tolerance`) for full Dart 3 compatibility.
- Removed redundant imports and unused fields across internal files.
- Fixed `example/analysis_options.yaml` include path issue.
- Achieved **100% static analysis score** on pub.dev.
- Minor documentation and formatting improvements.

---

## 1.0.0 – 2025-06-08

### Initial release of Pullex — a modern refresh & load controller for Flutter
- Forked from `flutter_pulltorefresh`, completely reworked and published as **`pullex`**.
- Compatible with **Flutter 3.22.x–3.32.x** and **Dart 3.x**.
- Improved architecture, safer indicator states, and fixed scroll edge behavior.
- Added new headers:  
  `StretchHeader`, `WaterDropHeader`, `MaterialClassicHeader`, `CustomHeader`, `TwoLevelHeader`, `BaseHeader`.
- Full localization support (12 languages).
- API cleanup, better defaults, and comprehensive inline documentation.
- Includes a working example app, flexible indicators, and production-ready localization.

Contributions welcome!
