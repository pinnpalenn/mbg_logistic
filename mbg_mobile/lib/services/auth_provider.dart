// lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _username;
  String? _password;
  bool _isLoading = false;
  String? _error;

  String? get username => _username;
  bool get isLoggedIn => _username != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ApiService get apiService => ApiService(username: _username, password: _password);

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('mbg_username');
    _password = prefs.getString('mbg_password');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tempApi = ApiService(username: username, password: password);
      await tempApi.login(username, password);

      _username = username;
      _password = password;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('mbg_username', username);
      await prefs.setString('mbg_password', password);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tempApi = ApiService();
      await tempApi.register(username, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _username = null;
    _password = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mbg_username');
    await prefs.remove('mbg_password');
    notifyListeners();
  }
}
