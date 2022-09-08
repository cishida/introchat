import 'dart:async';
import 'package:introchat/core/models/user/user.dart';

abstract class AuthService {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future currentAuthHeaders();
  Future<User> signInAnonymously();
  Future<void> signInWithGoogle();
  void sendVerificationCode(String phone);
  Future<User> signInWithPhone(String smsCode);
  Future<void> signOut();
  void dispose();
}
