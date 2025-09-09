Using cloud DB to store & sync with local database.

## Cloud Firestore

- dùng flutterfire cli để xử lý hầu hết các bước để thêm Firebase vào Flutter project:

  1. `flutter doctor` kiểm tra flutter
  2. `npm i -g firebase-tools` để install
  3. `firebase login` để đăng nhập vào tài khoản sử dụng và cho phép cli quyền thực hiện
  4. `dart pub global activate flutterfire_cli` để có folder chứa file .bat tương ứng của flutterfire.
  5. Thêm đường dẫn vào biến path (thủ công trên window -> enviroment, command trên mac/linux)
  6. Mở đường dẫn tương ứng của Flutter project và add package firebase_core: `flutter pub add firebase_core`
  7. `flutterfire configure` để chọn Firebase project:
     - có thể chọn project đã có
     - hoặc tạo mới project
  8. Chọn các OS mà Flutter app muốn hỗ trợ với Firebase để tạo file **lib\firebase_options.dart**
  9. Thay đổi `main` để chạy tương thích với Firebase:

  ```
  import 'package:emolog/firebase_options.dart';
  import 'package:firebase_core/firebase_core.dart';
  Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      runApp(const myApp())
  }
  ```

- thêm cloud firestore vào project:
  1. `flutter pub add cloud_firestore` để thêm package
  2. Tạo logic kết nối firestore_service với Cloud Firestore:
