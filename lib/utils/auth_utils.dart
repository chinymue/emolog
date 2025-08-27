import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

const String kPasswordPlaceholder = '*******';

String generateSalt([int length = 16]) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
