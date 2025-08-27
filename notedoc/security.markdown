## Security

- ở flutter có các lựa chọn phổ biến là `bcrypt`, `crypto` (SHA256), `encrypt` (AES/ChaCha20).
- khuyến nghị lên dùng `crypto`treen app cá nhân / MVP, chỉ nên sử dụng `bcrypt` khi có server riêng để migrate sang chứ không chạy trực tiếp trên client.
- `encrypt` cho phép lưu mật khẩu kiểu đối xứng cho phép hiển thị mật khẩu gốc.

### bcrypt

- đơn giản, chạy thẳng trên flutter/dart.
- không cần lưu salt, có cơ chế chống brute-force, bảo mật mạnh mẽ.
- chậm hơn crypto khi cần hash, verify password.
- tiêu tốn tài nguyên CPU khá nặng, chi phí tính toán cố định cao.

#### Performane

(Số liệu mang tính tương đối, tham khảo nhiều nguồn)

- hash 1 password với cost mặc định 10 / verify: ~ 100-200ms (pc/laptop), ~ 300-500ms (low-tier mobile)
- UX: delay khi đăng ký rõ ràng (0.3-0.5s cho phản hồi)

#### Implement

1. add package: `flutter pub add bcrypt`
2. using inside app:

```
import 'package:bcrypt/bcrypt.dart';

final hashed = BCrypt.hashpw("mypassword", BCrypt.gensalt());
final ok = BCrypt.checkpw("mypassword", hashed); // true
```

### crypto

- nhanh, gọn, không phụ thuộc native.
- là one-way hash nên cần lưu salt, pepper cho user tránh rainbow table attack.
- không tiêu tốn tài nguyên (rất nhẹ), thời gian thực hiện gần như tức thì.

#### Performance

(Số liệu mang tính tương đối, tham khảo nhiều nguồn)

- Hash 1 password / verify: vài microsec đến < 1ms, gần như tức thì kể cả trên low-tier mobile.
- UX: không cảm nhận được độ trễ.

#### Implement

1. add package: `flutter pub add crypto`
2. using inside app:

```
import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
```
