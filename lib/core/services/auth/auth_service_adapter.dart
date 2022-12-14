import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:introchat/core/models/user/user.dart';
import 'package:introchat/core/services/auth/auth_service.dart';
import 'package:introchat/core/services/auth/firebase_auth_service.dart';
import 'package:introchat/core/services/auth/mock_auth_service.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  StreamSubscription<User> _firebaseAuthSubscription;
  StreamSubscription<User> _mockAuthSubscription;

  void _setup() {
    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((User user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
    _mockAuthSubscription =
        _mockAuthService.onAuthStateChanged.listen((User user) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<User> _onAuthStateChangedController =
      StreamController<User>.broadcast();
  @override
  Stream<User> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<User> currentUser() => authService.currentUser();

  @override
  Future currentAuthHeaders() => authService.currentAuthHeaders();

  @override
  Future<User> signInAnonymously() => authService.signInAnonymously();

  @override
  Future<void> signInWithGoogle() => authService.signInWithGoogle();

  @override
  void sendVerificationCode(String phone) =>
      authService.sendVerificationCode(phone);

  @override
  Future<User> signInWithPhone(String smsCode) =>
      authService.signInWithPhone(smsCode);

  @override
  Future<void> signOut() => authService.signOut();
}
