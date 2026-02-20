import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Méthode déjà existante
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Méthode ajoutée : Register
  Future<void> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.register(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithGoogle();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Méthode ajoutée : Logout
  Future<void> logout() async {
    await _authService.logout();
  }
}
