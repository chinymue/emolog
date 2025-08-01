#### use lists

- chỉ dùng `ListView.builder()` khi danh sách dài (50+) và cần hiệu suất. Nếu ít thì dùng `SingleChildScrollView`, `ListView`.

> `ListView` & `ListTile` widget:

```
ListView(
  children: const <Widget>[
    ListTile(leading: Icon(Icons.map), title: Text('Map')),
    ListTile(leading: Icon(Icons.photo_album), title: Text('Album')),
    ListTile(leading: Icon(Icons.phone), title: Text('Phone')),
  ],
),
```

- list theo chiều ngang: `scrollDirection: Axis.horizontal`
- chú ý cần wrap listview vào container giới hạn chiều cao, hoặc `Expanded` trừ khi dùng `ListView.builder()`.
- thêm divider / khoảng cách giữa các item: `ListView.separated`

> dùng `ListView.builder()` để lazy load, cần truyền `itemCount` và `itemBuilder`:

```
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```
