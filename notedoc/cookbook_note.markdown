## Project working on: emoLog

### Các tính năng yêu cầu theo giai đoạn:

1. Nền tảng và các chức năng cơ bản:

- Nhập cảm xúc, nội dung, tên ngày (Form: validation, changes)
- Lưu dữ liệu cục bộ (Persistence: store key-value/disk, r&w files)
- Di chuyển giữa các màn hình: nhập - log - chi tiết (navigation: new screen & back, send & return data to other screen)
- Hiển thị danh sách các log cảm xúc (List: used, long list, list w/ spaced items)
- Tùy biến giao diện phù hợp cảm xúc (Design: custom font, themes - colors & styles)

2. UI/UX đẹp hơn:

- Hiệu ứng khi mở card, chuyển trạng thái cảm xúc (Animation: Fade io widget, properties of container)
- Làm UI thú vị, tự nhiên (EffectS: shimmer loadding, expandable FAB, typing indicator)
- Cho phép người dùng xóa cảm xúc bằng swipe (Gestures: handle taps, swipe to dismiss)
- Thông báo lưu thành công / xóa log (Design: snackbar)

3. Tính năng mở rộng:

- Đồng bộ cloud firebase (Networking: send & fetch data w/ internet, parse json)
- Gắn ảnh vào log (Plugins: take pic using camera)
- Hiệu ứng chuyển cảnh có cảm xúc động (Navigation + Animation: Animate widget across screens)

4. Kiểm thử và bảo trì cho release

- Đảm bảo UI hoạt động (Testing: widget test, find widgets, tap drag & enter text)
- Kết nối với Firebase Carashlytics/ Sentry để theo dõi người dùng

#### Checklist

##### 📋 Forms

- [x] `Build a form with validation` – tạo form nhập cảm xúc, ngày, nội dung
- [ ] `Create and style a text field` – chỉnh sửa giao diện ô nhập
- [x] `Handle changes to a text field` – cập nhật giá trị khi người dùng gõ
- [x] `Retrieve the value of a text field` – lấy dữ liệu khi nhấn nút "Lưu"

##### 💾 Persistence

- [ ] `Store key-value data on disk` – dùng `SharedPreferences` để lưu cảm xúc
- [x] `Read and write files` – dùng `File` để ghi nhật ký vào file (nếu không dùng SQLite)
- [ ] `Persist data with SQLite` – (nâng cao hơn) dùng database để lưu nhiều log

##### 📃 Lists

- [x] `Use lists` – hiển thị danh sách log cảm xúc
- [x] `Create a list with spaced items` – tạo card có khoảng cách đẹp
- [x] `Work with long lists` – xử lý scroll mượt

##### 🧭 Navigation

- [ ] `Navigate to a new screen and back` – từ màn nhập đến màn lịch sử
- [ ] `Send data to a new screen` – chuyển dữ liệu log đến màn chi tiết
- [ ] `Return data from a screen` – trả dữ liệu (nếu sửa log)
- [ ] `Navigate with named routes` – cấu trúc điều hướng rõ ràng hơn

##### 🎨 Design

- [ ] `Use a custom font` – font nhẹ nhàng, phù hợp nhật ký
- [ ] `Use themes to share colors and font styles` – set màu theo mood
- [ ] `Display a snackbar` – hiển thị thông báo khi lưu log thành công

##### 🎞️ Animation & Effects

- [ ] `Fade a widget in and out` – hiệu ứng khi hiển thị log
- [ ] `Animate the properties of a container` – highlight log được chọn
- [ ] `Create a shimmer loading effect` – hiệu ứng chờ khi tải log
- [ ] `Create an expandable FAB` – nút thêm log mở rộng đẹp mắt
- [ ] `Create a typing indicator` – gợi ý khi nhập nội dung?

##### ✋ Gestures

- [ ] `Handle taps` – click để xem chi tiết
- [ ] `Implement swipe to dismiss` – vuốt để xoá log

##### 🧪 Testing (cơ bản)

- [ ] `An introduction to widget testing` – kiểm tra hiển thị list
- [ ] `Find widgets`, `Tap, drag, and enter text` – test thao tác nhập cảm xúc

##### ☁️ Networking (nếu cần)

- [ ] `Send data to the internet`, `Fetch data from the internet` – đồng bộ nhật ký
- [ ] `Parse JSON in the background` – khi tải log từ server

##### 📸 Plugins

- [ ] `Take a picture using the camera` – đính kèm ảnh cho nhật ký

##### 🛠 Maintenance

- [ ] `Report errors to a service` – gửi lỗi về Firebase hoặc Sentry

##### 🧪 Testing nâng cao

- [ ] `An introduction to integration testing` – test toàn app
- [ ] `Performance profiling` – kiểm tra hiệu suất
