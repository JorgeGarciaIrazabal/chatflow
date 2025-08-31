import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/auth/repository/auth_repository.dart';
import 'package:chatflow/src/core/models/user_model.dart';

class AuthController extends ChangeNotifier {
  AuthRepository authRepository;
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController({required this.authRepository}) {
    checkAuthStatus();
  }

  // Getters
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _errorMessage = null;
    notifyListeners();
  }

  // Set error state
  void _setError(String message) {
    _isLoading = false;
    _errorMessage = message;
    notifyListeners();
  }

  // Set authenticated state
  void _setAuthenticated(User user) {
    _user = user;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Set unauthenticated state
  void _setUnauthenticated() {
    _user = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    _setLoading(true);

    try {
      final user = await authRepository.login(
        email: email,
        password: password,
      );
      _setAuthenticated(user);
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    _setLoading(true);

    try {
      final user = await authRepository.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      _setAuthenticated(user);
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await authRepository.logout();
      _setUnauthenticated();
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setError(e.toString());
    }
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        _setAuthenticated(user);
      } else {
        _setUnauthenticated();
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      _setUnauthenticated();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
