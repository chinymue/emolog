### Navigate

#### Navigator back & forth

- is a widget and navigate each screen as widgets, work like a **stack** of widget to show.
- `Navigator.push()` to add a `Route` (ur custom widget) in stack and `Navigator.pop()` to remove current `Route` and return to previous one.
- should create platform-specific route for better animation.
- other method to try:
  - `pushAndRemoveUntil`: Adds a navigation route to the stack and then removes the most recent routes from the stack until a condition is met.
  - `pushReplacement`: Replaces the current route on the top of the stack with a new one.
  - `replace`: Replace a route on the stack with another route.
    ` `replaceRouteBelow`: Replace the route below a specific route on the stack.
  - `popUntil`: Removes the most recent routes that were added to the stack of navigation routes until a condition is met.
  - `removeRoute`: Remove a specific route from the stack.
    removeRouteBelow: Remove the route below a specific route on the stack.
  - `restorablePush`: Restore a route that was removed from the stack.

> use of `Navigator.push()` and `Navigator.pop()`:

`Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPageWidget()))` // in FirstPageWidget, often in button's method onPressed / onTap

`Navigator.pop()` // in SecondPageWidget, often in button's method onPressed / onTap

#### Send data via Navigator.push()

1. using some var to hold data, pass via widget field: `SecondPageWidget(datafield: data)`

> Define that widget:

`const SecondPageWidget({super.key, required this.datafield});`

`final type datafield;`

> passing data:

`Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPageWidget(datafield: data)))`

2. using `RouteSettings` to hold data (no need to define field for widget):

- `ModalRoute.of()` to access current route with argument in settings (`RouteSettings`)

> passing:

```
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SecondPageWidget(),
    settings: RouteSettings(arguments: data)))
```

> using passed data (within a widget build because need `context`):

`final data = ModalRoute.of(context)!.settings.arguments as [[datatype]];`

#### Return data via Navigator.pop()

- passing literly an argument:

`Navigator.push(context, data)`

#### Navigate with named routes

- define routes in `MaterialApp` constructor w/ fields like `initialRoute`, `routes`. DO NOT define `home` property.

```
MaterialApp(
  title: 'Named Routes Demo',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => const FirstScreen(),
    // When navigating to the "/{{second}}" route, build the SecondScreen widget.
    '/{{second}}': (context) => const SecondScreen(),
  },
)
```

- `Navigator.pushNamed()` để chuyển đến route với name đã được định nghĩa: `Navigator.pushNamed(context, '/name')`

- `arguments` để chỉ định dữ liệu muốn chuyển trong `.pushNamed()`. Dữ liệu có thể là bất kỳ kiểu nào: `Navigator.pushNamed(context, '/logs', arguments: data)`

- có thể năng cấp điều hướng sử dụng `onGenerateRoute` trong `MaterialApp` để xử lý tất cả các `.pushNamed` nhằm tách điều hướng ra khỏi widget. Phù hợp với các app lớn.

> kiểu if-else:

```
MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/detail') {
      final log = settings.arguments as NoteLog;

      return MaterialPageRoute(
        builder: (context) => DetailPage(log: log),
      );
    }

    assert(false, 'Unknown route: ${settings.name}');
    return null;
  },
);
```

> kiểu switch-case:

```
MaterialApp(
  onGenerateRoute: (settings) {
    switch (settings.name) {
      case '/history':
        final args = settings.arguments as List<NoteLog>;
        return MaterialPageRoute(
          builder: (_) => HistoryLogPage(logs: args),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => NotFoundPage(),
        );
    }
  },
);
```

#### Widget Scaffold và bottomNavigationBar

- Nếu không giới hạn chiều rộng thì sẽ trải toàn bộ width của Scaffold (tức là toàn bộ width của màn hình).
- Nếu không giới hạn chiều cao mà sử dụng các widget như `Align`, `Center` sẽ khiến `bottomNavigationBar` chiếm **toàn bộ không gian** của `body` của `Scaffold`.

```
 bottomNavigationBar: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      height: 30,
      width: 160,
      child: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Go back'),
        ),
      ),
    ),
  ),
),
```
