> Stuff in {{}} indicate that you can name that part whatever you want.

### Persistance

- Refer to how you save / store data in local.
- Have different ways according to what kind of data you want to store:
  - **shared_preferences** plugin/package: small collection (KB), format often is key-value.
  - **path_provider** plugin w/ **dart:io**: bigger (MB), store in file(s), and all logic have to do manually.
  - SQLite (**sqflite** plugin/package (only support macOS, iOS, Android), **drift**,...): sql data and query, often use when data is big.

#### shared_perferences

- add package as a dependency: `flutter pub add shared_preferences`
