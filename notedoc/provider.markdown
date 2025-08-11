Tired of f^cking call `setState` and nothing change as your wish? or have to use `WillPopScope` but there is an anoying warning say it's deprecated? use `provider` :).
[Doc - Provider](https://pub.dev/documentation/provider/latest/)

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

- có thể dùng `MultiProvider` để wrap phần `MaterialApp` để dùng nhiều provider.

  > example:

        ```
        MultiProvider(
            providers: [
                ChangeNotifierProvider(
                    create: (context) => LogProvider(),
                ),
            ],
            child: MaterialApp()
        )
        ```

5.  Use `Provider` inside widgets: `Provider.of`, `Consumer`, `context.watch()`, `Selector`,...

- `context.watch<T>()` để widget listen changes ở T.

  > example: `context.watch<LogProvider>().logs`

- `context.read<T>()` để trả về T mà không listen. Thường dùng để thay đổi data trong provider.
  > example: `context.read<UserProvider>().changeUsername(newUserName: userNameController)`
