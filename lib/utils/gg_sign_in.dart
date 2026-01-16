// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

/// ===================================================================================
/// Service not working now, will implement later if have time
/// ===================================================================================

// class AuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(FirebaseAuth instance);

//   Future<User?> signInWithGoogle() async {
//     try {
//       // Khởi tạo Google Sign-In
//       await _googleSignIn.initialize();

//       // Xác thực người dùng
//       final GoogleSignInAccount? googleUser = await _googleSignIn
//           .authenticate();
//       if (googleUser == null) {
//         return null; // Người dùng hủy bỏ đăng nhập
//       }

//       // Lấy thông tin xác thực từ Google
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Tạo đối tượng OAuthCredential từ thông tin xác thực
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       // Đăng nhập vào Firebase
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithCredential(credential);

//       return userCredential.user;
//     } catch (e) {
//       print('Lỗi đăng nhập Google: $e');
//       return null;
//     }
//   }

// ignore_for_file: dangling_library_doc_comments

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await FirebaseAuth.instance.signOut();
//   }
// }
