import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/logger.dart';

class AuthService {
  String? _token;
  static const String baseUrl = 'http://localhost:3000/api/v1';

  AuthService({String? token}) : _token = token;

  void updateToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      Logger.log('Register response status: ${response.statusCode}');
      Logger.log('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      Logger.log('Register error', error: e);
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      Logger.log('Login response status: ${response.statusCode}');
      Logger.log('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      Logger.log('Login error', error: e);
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Fetch profile failed',
        };
      }
    } catch (e) {
      Logger.log('Fetch profile error', error: e);
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    String? password,
    String? profileImage,
    Map<String, dynamic>? preferences,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          if (password != null) 'password': password,
          if (profileImage != null) 'profileImage': profileImage,
          if (preferences != null) 'preferences': preferences,
        }),
      );

      Logger.log('Update profile response status: ${response.statusCode}');
      Logger.log('Update profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Update profile failed',
        };
      }
    } catch (e) {
      Logger.log('Update profile error', error: e);
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'users': data,
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to fetch users',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }
}
