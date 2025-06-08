# FAQ — pullex

---

## 🇬🇧 Frequently Asked Questions

### 1️⃣ How to monitor the ScrollView position? Should I use ScrollController.addListener?

→ Yes. Pass your own ScrollController to the child ScrollView → and add addListener.

---

### 2️⃣ What is the purpose of position and scrollController exposed in PullexRefreshController?

→ scrollController was kept for compatibility.  
→ The main purpose is to control the scroll manually (for example, scroll to the bottom in a chat), without requiring addListener.

---

### 3️⃣ Error "Horizontal viewport was given unbounded height." How to solve?

→ Child (like PageView) must be wrapped in a container with constrained height.

---

### 4️⃣ I want to disable pull-up loading when the content does not fill the screen, but my item heights are dynamic. How to solve?

→ Use `hideFooterWhenNotFull` in RefreshConfiguration.

---

### 5️⃣ Can the indicator use custom frame animation (GIF)?

→ Yes, with [flutter_gifimage](https://github.com/peng8350/flutter_gifimage). Example: `example/lib/ui/custom_header/custom_header_example.dart`.

---

### 6️⃣ How to configure Spring Description parameters? How to achieve desired rebound effect?

→ You need to understand the Flutter physics API. It requires some basic physics/math knowledge.

---

### 7️⃣ On Android, when using ShowAlways Footer style, how to disable bounce?

→ Set `maxUnderScrollExtent = 0.0` in RefreshConfiguration.

---

### 8️⃣ I want to start loading when the user scrolls halfway, not at the bottom. How to configure?

→ Use `footerTriggerDistance` in RefreshConfiguration. You can calculate height via MediaQuery or LayoutBuilder.

---

### 9️⃣ Why does ListView not scroll to top on iOS status bar double-tap?

→ If you pass ScrollController to child, it is not PrimaryScrollController → auto scroll will not work. Also check Scaffold hierarchy.

---

### 10️⃣ Why is part of the list hidden when using CupertinoNavigationBar?

→ CustomScrollView does not inject padding (like BoxScrollView). You need to add padding or SafeArea manually.

---

### 11️⃣ Is the package compatible with other gesture libraries?

→ Since `pullex` does not use GestureDetector/NotificationListener → it should be compatible with most gesture libraries. Some edge cases may require custom ScrollPhysics.

---

### 12️⃣ I want footer to stick to content in "no more data" state, but stay at bottom otherwise. Is this possible?

→ Yes, use `shouldFooterFollowWhenNotFull` in RefreshConfiguration.

---

### 13️⃣ Why is SingleChildScrollView not supported?

→ SingleChildScrollView uses SingleChildViewport → cannot add header/footer. Instead, pass it as PullexRefresh child.

---

### 14️⃣ Why doesn’t refresh or load more trigger when pulling to max distance?

→ On Android this can happen if `maxOverScrollExtent` or `maxUnderScrollExtent` are not large enough. Make sure they are larger than `triggerDistance`.

---

### 15️⃣ Why does scrolling performance degrade with a large amount of data?

→ Often caused by using `shrinkWrap = true` and `NeverScrollPhysics`. The correct way is to use ScrollView directly as PullexRefresh child.

---

## 🇺🇦 Часті питання

### 1️⃣ Як відстежувати зміну положення ScrollView? Потрібно використовувати ScrollController.addListener?

→ Так. Передайте свій ScrollController у child (ScrollView) → і додайте addListener.

---

### 2️⃣ Навіщо в PullexRefreshController є position і scrollController?

→ scrollController залишено для зворотної сумісності.  
→ Основне призначення — вручну керувати прокруткою (наприклад у чаті — прокрутити донизу), без обов'язкового addListener.

---

### 3️⃣ Помилка "Horizontal viewport was given unbounded height." Як вирішити?

→ Child (наприклад PageView) має бути обгорнутий у контейнер з обмеженою висотою.

---

### 4️⃣ Як вимкнути pull-up loading, якщо контент не займає повний екран (різна висота itemʼів)?

→ Використовуйте `hideFooterWhenNotFull` у RefreshConfiguration.

---

### 5️⃣ Чи можна використати кастомну анімацію (GIF) для індикатора?

→ Так, за допомогою [flutter_gifimage](https://github.com/peng8350/flutter_gifimage). Приклад: `example/lib/ui/custom_header/custom_header_example.dart`.

---

### 6️⃣ Як працюють параметри Spring Description? Як отримати бажаний ефект відскоку?

→ Це фізична модель. Потрібно вивчити відповідний API Flutter. Потребує базового розуміння фізики та математики.

---

### 7️⃣ На Android при використанні ShowAlways Footer стиль — як прибрати відскок?

→ Встановіть `maxUnderScrollExtent = 0.0` у RefreshConfiguration.

---

### 8️⃣ Як зробити, щоб підвантаження починалося не у кінці, а посередині екрану?

→ Використовуйте `footerTriggerDistance` у RefreshConfiguration. Висоту можна обрахувати через MediaQuery або LayoutBuilder.

---

### 9️⃣ Чому на iOS при подвійному натисканні на статус-бар ListView не прокручується вгору?

→ Якщо ScrollController передано у child, він не є PrimaryScrollController → автоматична прокрутка не працює. Також перевірте правильність Scaffold у ієрархії.

---

### 10️⃣ Чому при використанні CupertinoNavigationBar частина списку перекривається?

→ CustomScrollView не додає padding автоматично (як BoxScrollView). Потрібно додати padding або SafeArea вручну.

---

### 11️⃣ Чи сумісний пакет з іншими gesture бібліотеками?

→ У `pullex` GestureDetector/NotificationListener більше не використовується → сумісність з більшістю gesture бібліотек. У специфічних випадках може знадобитися своя ScrollPhysics.

---

### 12️⃣ Як зробити, щоб footer у стані "немає даних" був привʼязаний до контенту, а в інших — залишався знизу?

→ Використовуйте `shouldFooterFollowWhenNotFull` у RefreshConfiguration.

---

### 13️⃣ Чому не підтримується SingleChildScrollView?

→ SingleChildScrollView використовує SingleChildViewport → неможливо додати header/footer. Потрібно передати його як child PullexRefresh.

---

### 14️⃣ Чому не спрацьовує refresh або load more при максимальному перетягуванні?

→ На Android це може бути через неправильні значення `maxOverScrollExtent` або `maxUnderScrollExtent`. Перевірте, щоб вони були більшими за `triggerDistance`.

---

### 15️⃣ Чому з великою кількістю даних скрол починає працювати повільно?

→ Зазвичай це через `shrinkWrap = true` + `NeverScrollPhysics`. Правильно — використовувати ScrollView напряму у PullexRefresh.

---
