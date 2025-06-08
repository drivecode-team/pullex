# Notice

## 🇬🇧 Notice for users of pullex package

### PullexRefreshController

- Do not create `PullexRefreshController` multiple times during the lifecycle of `PullexRefresh`.
- Each `PullexRefresh` must have its own `PullexRefreshController`. Do not share one controller across multiple `PullexRefresh` instances (especially in `TabBarView` or `PageView`).

### PullexRefresh

- Do not deeply nest `ScrollView` under complex widget trees. `PullexRefresh` does not rely on `NotificationListener`.
- Use `enablePullUp` and `enablePullDown` to disable pull-up / pull-down functionality when needed.
- If child is not a `ScrollView`, be aware that height constraints might be unbounded.
- Avoid using `SingleChildScrollView` as the child directly. If needed — wrap it properly.
- If adding a background — wrap the `PullexRefresh` itself, not its child.

### RefreshStyle

- The refresh indicator works via dynamic height change. Using `Align` helps achieve better effect.
- `MaterialClassicHeader` / `ClassicHeader` does not work well with `Icon` widgets. Using `Icon` may cause unexpected visual artifacts.

### Footer Indicator

- If your `ScrollView` contains complex `Sliver` elements — automatic detection of "not full page" may not work perfectly.
- In such cases — set `hideWhenNotFull` to false and manage this manually using a Boolean flag.

### NestedScrollView

- Place `ScrollController` properly within `NestedScrollView`. It will not work if simply used in the `child`.

### CustomScrollView

- Using `UnFollow` refresh style with `SliverAppBar` or `SliverHeader` as the first element may cause layout issues.
- Recommended workaround: add a `SliverToBoxAdapter` before the first element.

---

## 🇺🇦 Інформація для користувачів пакету pullex

### PullexRefreshController

- Не створюйте `PullexRefreshController` кілька разів протягом життєвого циклу `PullexRefresh`.
- Для кожного `PullexRefresh` використовуйте окремий `PullexRefreshController`. Не використовуйте один controller для кількох PullexRefresh (особливо у `TabBarView` або `PageView`).

### PullexRefresh

- Не загортайте `ScrollView` глибоко у складну ієрархію віджетів. `PullexRefresh` працює без використання `NotificationListener`.
- Щоб вимкнути pull-up / pull-down — використовуйте параметри `enablePullUp` та `enablePullDown`.
- Якщо `child` не є `ScrollView`, висота може бути некоректною (unbounded height).
- Не використовуйте `SingleChildScrollView` напряму як `child`. Якщо потрібно — правильно його обгорніть.
- Якщо хочете додати фон — обгорніть сам `PullexRefresh`, а не його `child`.

### Стилі оновлення (RefreshStyle)

- Індикатор оновлення реалізовано через динамічну зміну висоти. Використовуйте `Align` для кращого ефекту.
- `MaterialClassicHeader` / `ClassicHeader` не працюють коректно з `Icon`. Можливі візуальні артефакти при використанні `Icon`.

### Footer Indicator

- Якщо у вашому `ScrollView` є складні `Sliver` елементи — автоматичне визначення "неповної сторінки" може працювати некоректно.
- У таких випадках використовуйте `hideWhenNotFull = false` та керуйте цим вручну через Boolean прапорець.

### NestedScrollView

- `ScrollController` має бути коректно інтегрований у `NestedScrollView`. Просте використання у `child` не працює.

### CustomScrollView

- При використанні стилю `UnFollow` разом із `SliverAppBar` або `SliverHeader` першим елементом можуть виникати проблеми з версткою.
- Рекомендація: додайте `SliverToBoxAdapter` перед першим елементом.

---