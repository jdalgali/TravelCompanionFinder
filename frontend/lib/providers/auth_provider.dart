import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    loadStoredUser();
  }

  Future<void> loadStoredUser() async {
    try {
      _token = await _storage.read(key: 'auth_token');
      final userStr = await _storage.read(key: 'user_data');
      if (userStr != null) {
        _user = jsonDecode(userStr);
      }
      _authService.updateToken(_token);
      notifyListeners();
    } catch (e) {
      Logger.log('Error loading stored user', error: e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      if (result['success']) {
        _token = result['token'];
        _user = result['user'];
        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_data', value: jsonEncode(_user));
        _authService.updateToken(_token);
      } else {
        _error = result['message'];
      }

      return result;
    } catch (e) {
      Logger.log('Registration error in provider', error: e);
      _error = 'An unexpected error occurred';
      return {
        'success': false,
        'message': _error,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result['success']) {
        _token = result['token'];
        _user = result['user'];
        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(key: 'user_data', value: jsonEncode(_user));
        _authService.updateToken(_token);
      } else {
        _error = result['message'];
      }

      return result;
    } catch (e) {
      Logger.log('Login error in provider', error: e);
      _error = 'An unexpected error occurred';
      return {
        'success': false,
        'message': _error,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _user = null;
      _token = null;
      _error = null;
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_data');
      _authService.updateToken(null);
      notifyListeners();
    } catch (e) {
      Logger.log('Logout error in provider', error: e);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.updateProfile(
        name: name,
        email: email,
        password: password,
      );

      if (result['success']) {
        _user = result['user'];
        await _storage.write(key: 'user_data', value: jsonEncode(_user));
      } else {
        _error = result['message'];
      }

      return result;
    } catch (e) {
      Logger.log('Update profile error in provider', error: e);
      _error = 'An unexpected error occurred';
      return {
        'success': false,
        'message': _error,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
