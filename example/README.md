# Pullex Example

This folder contains full example usage of the [pullex](https://pub.dev/packages/pullex) package.

---

## Run the example:

```bash
flutter pub get
flutter run -d <device>
```

---

## Available examples:

| Example                      | Folder                                    |
|------------------------------|-------------------------------------------|
| BaseHeader Example           | example/lib/ui/base_header/               |
| CustomHeader Example         | example/lib/ui/custom_header/             |
| LoadMoreBaseHeader Example   | example/lib/ui/load_more_base_header/     |
| MaterialHeader Example       | example/lib/ui/material_header/           |
| StretchHeader Example        | example/lib/ui/stretch_header/            |
| TwoLevelRefresh Example      | example/lib/ui/two_level_refresh/         |
| WaterDropHeader Example      | example/lib/ui/water_drop_header/         |

---

## How to switch examples:

Open:

```bash
example/lib/main.dart
```

You can switch between examples by navigating to the corresponding screen.

---

## Notes:

- All examples are **independent**, you can copy them into your project.
- You can see how to use various indicators:
    - `BaseHeader`
    - `ClassicHeader`
    - `MaterialClassicHeader` & `WaterDropMaterialHeader`
    - `StretchCircleHeader` & `StretchHeader`
    - `TwoLevelHeader`
    - `CustomHeader`
    - `WaterDropHeader`
- You can also see advanced behaviors:
    - Load more with `LoadMoreBaseHeader`
    - Two level refresh
    - Dynamic header switching
    - Full control of refresh behaviors
