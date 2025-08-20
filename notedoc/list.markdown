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

```
ListTile(
  onTap: () => handleTap(),
  leading: IconButton(
    icon: Icon(
      Icons.monitor_heart,
      size: iconSize,
      color: log.isFavor
          ? colorScheme.primary
          : adjustLightness(colorScheme.primary, 0.4),
    ),
    onPressed: () => handleFavor(),
    splashRadius: kSplashRadius,
    tooltip: log.isFavor ? 'Unfavourite' : 'Favourite',
  ),
  title: Text(
    shortenText(plainTextFromDeltaJson(log.note)),
    style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
  ),
  subtitle: Text(
    formatShortDateTime(log.date),
    style: textTheme.labelMedium?.copyWith(fontWeight: kFontWeightRegular),
  ),
  trailing: Icon(
    moods[log.labelMood],
    size: iconSizeLarge,
    color: colorScheme.primary,
  ),
);
```

- list theo chiều ngang: `scrollDirection: Axis.horizontal`
- chú ý cần wrap listview vào container giới hạn chiều cao, hoặc `Expanded` trừ khi dùng `ListView.builder()`. Có thể dùng `LayoutBuilder` & `IntrinsicHeight` để wrap cho toàn màn hình.

  > dùng `LayoutBuilder`:

  ```
  LayoutBuilder(
    builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
          child: IntrinsicHeight()
        )
      );
    }
  )
  ```

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
