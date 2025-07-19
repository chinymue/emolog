> Stuff in {{}} indicate that you can name that part whatever you want.

### Persistance

- Refer to how you save / store data in local.
- Have different ways according to what kind of data you want to store:
  - **shared_preferences** plugin/package: small collection (KB), format often is key-value.
  - **path_provider** plugin w/ **dart:io**: bigger (MB), store in file(s), and all logic have to do manually.
  - SQLite (**sqflite** plugin/package (only support macOS, iOS, Android), **drift**,...): sql data and query, often use when data is big.

#### shared_perferences

- add package as a dependency: `flutter pub add shared_preferences`
- import when use: `import 'package:shared_preferences/shared_preferences.dart';`
- only work with these data type: `int`, `double`, `bool`, `String`, and `List<String>`.
- no guarantee that data will be persisted across app restarts.
- testing support: `setMockInitialValues`.
  `SharedPreferences.setMockInitialValues(<String, Object>{'{{counter}}': 2});`
- `{{prefs}}.clear()`: để xoá tất cả.

> read data: should wrap by a Future<void> function

```
final {{prefs}} = await SharedPreferences.getInstance();

// Try reading the counter value from persistent storage.
// If not present, null is returned, so default to 0.
final {{counter}} = {{prefs}}.getInt('{{counter}}') ?? 0;
```

> save data: should wrap by a Future<void> function

```
// Load and obtain the shared preferences for this app.
final {{prefs}} = await SharedPreferences.getInstance();

// Save the counter value to persistent storage under the 'counter' key.
await {{prefs}}.setInt('{{counter}}', {{counter}});
```

> remove data: should wrap by a Future<void> function

```
final {{prefs}} = await SharedPreferences.getInstance();

// Remove the counter key-value pair from persistent storage.
await {{prefs}}.remove('{{counter}}');
```

#### path_provider & dart:io
