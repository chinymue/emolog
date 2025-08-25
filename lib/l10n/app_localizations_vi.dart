// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Emolog';

  @override
  String get pageHome => 'Trang chủ';

  @override
  String get pageSettings => 'Cài đặt';

  @override
  String get pageHistory => 'Lịch sử';

  @override
  String get pageDetail => 'Chi tiết nhật ký';

  @override
  String get restoreAcc => 'Thiết lập lại tài khoản';

  @override
  String get restoreSettings => 'Đặt lại cài đặt mặc định';

  @override
  String get username => 'Tên đăng nhập';

  @override
  String get password => 'Mật khẩu';

  @override
  String get fullname => 'Nickname';

  @override
  String get email => 'Email';

  @override
  String get avatarUrl => 'Avatar';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Chế độ hiển thị';

  @override
  String get submit => 'Lưu';

  @override
  String get changeLanguage => 'English';

  @override
  String get saveChanges => 'Lưu thay đổi';

  @override
  String get saveChangesNotVaid => 'Không lưu được thay đổi';

  @override
  String get saveFailed => 'Lưu thất bại';

  @override
  String get saveSuccess => 'Lưu thành công';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get validEmpty => 'Không được để trống';

  @override
  String logRecorded(int savedLogId) {
    return 'Nhật ký $savedLogId đã được ghi lại';
  }

  @override
  String get helloMessageNeutral => 'Hôm nay ổn chứ?';

  @override
  String get helloMessageBestie => 'Nay thế nào, kể nghe coi!';

  @override
  String get helloMessageMom => 'Con có chuyện gì muốn chia sẻ không?';

  @override
  String get moodTerrible => 'Tồi tệ';

  @override
  String get moodNotGood => 'Không ổn';

  @override
  String get moodChill => 'Cũng được';

  @override
  String get moodGood => 'Vui';

  @override
  String get moodAwesome => 'Tuyệt vời';

  @override
  String get toolbarShow => 'Hiện thanh công cụ';

  @override
  String get toolbarHidden => 'Ẩn thanh công cụ';

  @override
  String get toolbarBasic => 'Dùng thanh công cụ cơ bản';

  @override
  String get toolbarFull => 'Dùng thanh công cụ đầy đủ';

  @override
  String get logPlaceHolderNeutral => 'Ghi lại tâm trạng của bạn...';

  @override
  String get filtersClear => 'Xóa bộ lọc';

  @override
  String get filterMood => 'Lọc theo cảm xúc';

  @override
  String get filterMoodPoint => 'Lọc theo mức tâm trạng';

  @override
  String get filterFavor => 'Các nhật ký được yêu thích';

  @override
  String get filterFavorClear => 'Xóa lọc theo yêu thích';

  @override
  String get filterDateRange => 'Chọn khoảng thời gian';

  @override
  String get sortNewest => 'Xếp theo mới nhất';

  @override
  String get sortOldest => 'Xếp theo cũ nhất';

  @override
  String get logNotFound => 'Chưa có nhật ký phù hợp';

  @override
  String get logFavor => 'Yêu thích';

  @override
  String get logUnfavor => 'Bỏ yêu thích';

  @override
  String get logNotExist => 'Nhật ký không tồn tại';
}
