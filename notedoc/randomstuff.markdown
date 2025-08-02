### intl và DateTime

- chuyển dạng `DateTime` sang chuỗi `String` với định dạng tùy ý: `yyyy-mm-dd`, `HH:mm:ss`, `EEE` (Ngày trong tuần dạng ngắn), `EEEE` (Ngày trong tuần dạng dài),...

1. Thêm package vào `pubspec.yaml`: `flutter pub add intl`
2. Import vào file: `import 'package:intl/intl.dart';`
3. Các cách sử dụng:

> Thứ ngày tháng năm, giờ phút giây:

```
String formatFullDateTime(DateTime date) =>
    DateFormat('EEEE yyyy-MM-dd HH:mm:ss').format(date);
```

> Theo vị trí:

```
String formatShortWeekday(DateTime date, {String locale = 'vi_VN'}) {
  Intl.defaultLocale = locale;
  return DateFormat('EEE').format(date); // T7
}
```
