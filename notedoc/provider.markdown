Tired of f^cking call `setState` and nothing change as your wish? or have to use `WillPopScope` but there is an anoying warning say it's deprecated? use `provider` :).

1.  `flutter pub add provider`.
2.  `import 'package:provider/provider.dart';` at file use `ChangeNotifier` not file create one.
3.  Create a `ChangeNotifier` to manage state

    > example on counting:

         ```
         import 'package:flutter/material.dart';

         class CounterProvider extends ChangeNotifier {
         int _count = 0;

         int get count => _count;

         void increment() {
             _count++;
             notifyListeners(); // Cập nhật UI
         }
         }
         ```

4.  Wrap the highest (or parentalest) widget, covers all widgets need to share data/state, by `ChangeNotifierProvider` widget.

    > example stucture:

        ```
        void main() {
        runApp(
            ChangeNotifierProvider(
            create: (context) => CounterProvider(),
            child: MyApp(),
            ),
        );
        }
        ```

5.  Use `Provider` inside widgets: `Provider.of`, `Consumer`, `context.watch()`, `Selector`,...

- vấn đề không notify khi đang build: sử dụng `WidgetsBinding`:

```
    // trigger load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUser(userId: widget.userId);
    });
```
