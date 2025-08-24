### intl

#### DateTime

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

#### Language

- sử dụng `intl` với `locale` để thiết lập ngôn ngữ hiển thị trong `MaterialApp`. Dùng `ChangeNotifier` của `provider` để thay đổi UI theo tùy chọn:

  1. sửa `pubspec.yaml`: thêm setting dưới đây:

  ```
  flutter:
    generate: true
  ```

  2. tạo folder `l10n` trong `lib` chứa các file `app_XX.arb` tương tự:

  ```
  \\ lib/l10n/app_en.arb
  {
    "@@locale": "en",
    "appTitle": "Emolog",
    "home": "Home",
    "settings": "Settings"
  }
  ```

  3. chạy command sinh file: `flutter gen-l10n`.

  4. import file cần thiết vào `main` (chứa `MaterialApp`): `import './l10n/app_localizations.dart';`

  5. Sử dụng trong `locale` của `MaterialApp`:
     `supportedLocales: AppLocalizations.supportedLocales,`
     `localizationsDelegates: AppLocalizations.localizationsDelegates,`

  ```
  localizationsDelegates: const [
    ...AppLocalizations.localizationsDelegates,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    quill.FlutterQuillLocalizations.delegate,
  ],
  ```

### List

#### Cách đảo ngược list

- dùng `.reversed` sẽ trả về kiểu `Iterable` nên cần dùng thêm `.toList()` để trả về kiểu **List**.
  > `mylist.reversed.tolist()`

### Future

#### FutureBuilder

- widget này có thể nhận dữ liệu kiểu `Future` ở field `future` sau đó sẽ xử lý bằng `builder`.
  <<<<<<< HEAD
- # Cẩn thận sử dụng vì vẫn chưa áp dụng được thành công. Không dùng cho những dữ liệu cần thay đổi linh hoạt

  > > > > > > > b8bd79a071e1f544b3d4d28efd7ae0a34ba66d69

  > `FutureBuilder` example:

  ```
  FutureBuilder(
    future: _futurelogs,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {}
    }
  )
  ```
