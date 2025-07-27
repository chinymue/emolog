#### use custom font

- font cho app:

  - Sans-serif (chính): Inter
  - Viết tay / cảm xúc: Patrick Hand
  - tiêu đề tĩnh (optional): MerriweatherSans

- các định dạng file font hỗ trợ: `.ttc`, `.ttf`, `.otf`
- tải xuống file zip chứa các file font `.ttf`, chuyển vào thư mục `root/assets/fonts/..` và khai báo trong pubspec.yaml rồi chạy `flutter pub get` để lưu.
- có hai dạng file **static** và **\_opsz,wght** do ggfont đặt: opsz (optical size — cỡ chữ thông minh), wght (weight — độ đậm). Có thể chỉ có một trong hai.
- ngoài ra có thể sử dụng trực tiếp `GoogleFonts.` mà không cần setup gì: `GoogleFonts.oswald(fontSize: 30, fontStyle: FontStyle.italic)`.

> khai báo font:

```
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter/Inter-VariableFont_opsz,wght.ttf
        - asset: assets/fonts/Inter/Inter-Italic-VariableFont_opsz,wght.ttf
          style: italic
    - family: PatrickHand
      fonts:
        - asset: assets/fonts/PatricHand/PatrickHand-Regular.ttf
```

#### theme on color & text

- khai báo field `theme` trong `MaterialApp`. Có thể sử dụng `ThemeData()`, `ThemeData.light()`, `ThemeData.dark()`, `ThemeData.from(colorScheme:..., textTheme:...)`,...

- hạn chế sử dụng / phối màu theo cá nhân vì nó rất bruh

#### Snackbar

- có hỗ trợ tạo action để hoàn tác:

```
final snackBar = SnackBar(
  content: const Text('Yay! A SnackBar!'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {
      // Some code to undo the change.
    },
  ),
);
```
