# Changelog

## [1.0.0] - 2025-06-08

### Initial Release 🎉

**Pullex** is a modern refresh & load controller package for Flutter apps.

- Forked from [`flutter_pulltorefresh`](https://github.com/xxzj990-game/flutter_pulltorefresh) (MIT License) by Jpeng.
- Published as **pullex** package.

### ✅ Compatibility

- Fully compatible with **Flutter 3.22.x → 3.32.x** and latest stable versions.
- Supports **Dart 3.x**.

### 🚀 Improvements

- Reworked internal architecture:
  - safer `RefreshIndicator` & `LoadIndicator` states.
  - fixed multiple issues in `ScrollPosition` / `ScrollPhysics` on Flutter 3.x.
  - removed deprecated APIs from upstream version.
- Reorganized code structure:
  - `header/` → all header indicators
  - `internals/` → internal helpers & localization
  - `link_proxy/` → link header/footer proxies
  - `refresh/` → core refresh controller, notifier, configuration.
- Added `StretchHeader` and `StretchCircleHeader` (new flexible indicators).
- Improved `WaterDropHeader` and `WaterDropMaterialHeader` animations.
- Improved `MaterialClassicHeader` compatibility.
- Added `CustomHeader` and `CustomFooter` — easy to build custom UI indicators.
- Improved `TwoLevelHeader` behavior.
- Improved `BaseHeader` (simple default header).
- Fixed localization issues:
  - Rewritten `RefreshLocalizations` and `RefreshString` with extended language support.
  - Full support for:
    - 🇺🇸 English
    - 🇨🇳 Chinese
    - 🇷🇺 Russian
    - 🇺🇦 Ukrainian
    - 🇫🇷 French
    - 🇮🇹 Italian
    - 🇩🇪 German
    - 🇪🇸 Spanish
    - 🇯🇵 Japanese
    - 🇰🇷 Korean
    - 🇵🇹 Portuguese
    - 🇳🇱 Dutch
    - 🇸🇪 Swedish

### 🛠 API Cleanup

- Removed old `ClassicHeader` aliases.
- `RefreshConfiguration` refactored with better defaults.
- `RefreshController` API improved.
- Public API documented and ready for production.

### ✨ Summary

Pullex 1.0.0 is a modern and clean rewrite of `flutter_pulltorefresh`, with:
- fully working example app,
- flexible header/footer indicators,
- proper localization,
- safe for production.

---

Enjoy 🚀 — **contributions welcome!**
