# Pullex 🚀

A modern, flexible and production-ready **Pull-To-Refresh** & **Load-More** widget for Flutter.  
Forked from [flutter_pulltorefresh](https://github.com/xxzj990-game/flutter_pulltorefresh) — rewritten and modernized for **Flutter 3 & Dart 3** with improved architecture, localization, and full null-safety.

---

## ✨ What's New in 1.0.1

- Fixed and improved built-in localization strings.
- Renamed **`PullexRefreshController` → `RefreshController`** for a cleaner API.
- Updated deprecated Dart syntax (`typedef`, default parameters, `withOpacity`, and `tolerance`).
- Removed redundant imports and unused fields.
- Fixed analysis warnings in the example project.
- Achieved **100% pub.dev static analysis score** ✅
- Minor documentation and formatting improvements.

---

## 🔁 Migration from `PullexRefreshController` → `RefreshController`

In version **1.0.1**, the old class name **`PullexRefreshController`** was renamed to simply **`RefreshController`**  
to make the API cleaner and more intuitive.


### ❌ Before
```dart
final controller = PullexRefreshController();
```
### ✅ After
```dart
final controller = RefreshController();
```
> 💡 **Tip:** You only need to rename the class in your imports — no API behavior has changed.

---

## ⚙️ Features

- ✅ Modern architecture — Flutter 3.x & Dart 3 compatible
- ✅ Ready-to-use headers:
    - `BaseHeader`
    - `CustomHeader`
    - `MaterialClassicHeader`
    - `WaterDropHeader`
    - `StretchCircleHeader`
    - `TwoLevelHeader`
- ✅ Custom Footer support
- ✅ LinkHeader / LinkFooter proxy support
- ✅ Fully customizable and easy to integrate
- ✅ 12 built-in localizations
- ✅ Zero dependencies (pure Dart)
- ✅ Production-ready — used in live apps

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  pullex: ^1.0.1
```

## 🧩 Basic Usage
```dart
import 'package:pullex/pullex.dart';

final controller = RefreshController();

SmartRefresher(
  controller: controller,
  enablePullDown: true,
  enablePullUp: true,
  header: const MaterialClassicHeader(),
  onRefresh: () async {
    // your refresh logic
    controller.refreshCompleted();
  },
  onLoading: () async {
    // your load more logic
    controller.loadComplete();
  },
  child: ListView.builder(
  itemCount: 30,
  itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
  ),
);
```

---

## 🖼️ Examples

| Base Header | Custom Header | Load More Base Header | Material Header |
|-------------|---------------|----------------------|-----------------|
| ![Base Header](assets/gif/base_header.gif) | ![Custom Header](assets/gif/custom_header.gif) | ![Load More Base Header](assets/gif/load_more_base_header.gif) | ![Material Header](assets/gif/material_header.gif) |

| Stretch Circle Header | Two Level Refresh | Water Drop Header |  |
|-----------------------|-------------------|-------------------|--|
| ![Stretch Header](assets/gif/stretch_header.gif) | ![Two Level Refresh](assets/gif/two_level_refresh.gif) | ![Water Drop Header](assets/gif/water_drop_header.gif) |  |

---

## 🌍 Localization

Pullex supports 12 languages out of the box:

| Language | Code |
|----------|------|
| English  | en   |
| Chinese  | zh   |
| French   | fr   |
| Ukrainian| uk   |
| Italian  | it   |
| Japanese | ja   |
| German   | de   |
| Spanish  | es   |
| Dutch    | nl   |
| Swedish  | sv   |
| Portuguese (Brazil) | pt   |
| Korean   | ko   |

### Setup localization:

```dart
MaterialApp(
  localizationsDelegates: [
    RefreshLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    const Locale('en'),
    const Locale('uk'),
    const Locale('fr'),
    const Locale('de'),
    const Locale('es'),
    const Locale('pt'),
    const Locale('it'),
    const Locale('nl'),
    const Locale('sv'),
    const Locale('ko'),
    const Locale('ja'),
    const Locale('zh'),
  ],
)
```

---

## 🚚 Migration from `flutter_pulltorefresh`

Pullex is a **modernized fork** of `flutter_pulltorefresh`, fully compatible with Flutter 3:

- Cleaner and safer public API
- Updated internal scroll physics
- Improved headers and footers
- Built-in localization
- Actively maintained

---

## 📌 Example Project

You can find a complete example in:

```
example/lib/ui/
```

Each header type has a dedicated example:

```
ui/base_header/base_header_example.dart
ui/custom_header/custom_header_example.dart
ui/load_more_base_header/load_more_base_header_example.dart
ui/material_header/material_header_example.dart
ui/stretch_header/stretch_header_example.dart
ui/two_level_refresh/two_level_refresh_example.dart
ui/water_drop_header/water_drop_header_example.dart
```

Run:

```bash
flutter run -d your_device
```

---

## ❤️ Contributing

Contributions are welcome!  
Feel free to open issues or submit PRs to improve **Pullex**.

---

## 📜 License

MIT License — based on [flutter_pulltorefresh](https://github.com/xxzj990-game/flutter_pulltorefresh)  
by **Jpeng**

---

**Pullex — built for modern Flutter 🚀**  
Crafted with ❤️ by **Drivecode Team**

