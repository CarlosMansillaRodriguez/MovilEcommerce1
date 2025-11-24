import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/auth/service/http_client.dart';
import '../features/auth/models/auth_models.dart';

class AuthApi {
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final http.Response res = await HttpClient.post(
      '/api/v1/auth/login',
      {'email': email.trim(), 'password': password.trim()},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(data);
    } else {
      throw _error(res);
    }
  }

  /// Tu /auth/register NO garantiza {user, token}.
  /// Hacemos register y luego login para normalizar.
  static Future<AuthResponse> register({
    required String nombre,
    required String email,
    required String password,
    required int roleId, // 2 cliente | 3 chofer
  }) async {
    final http.Response reg = await HttpClient.post(
      '/api/v1/auth/register',
      {
        'nombre': nombre.trim(),
        'email': email.trim(),
        'password': password.trim(),
        'roleId': roleId,
      },
    );

    if (reg.statusCode < 200 || reg.statusCode >= 300) {
      throw _error(reg);
    }

    // login inmediato
    return login(email: email, password: password);
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final res = await HttpClient.post(
      '/api/v1/auth/forgotpassword',
      {'email': email.trim()},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw _error(res);
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    final res = await HttpClient.post(
      '/api/v1/auth/resetPassword',
      {'email': email.trim(), 'code': code.trim(), 'password': password.trim()},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw _error(res);
  }

  static Exception _error(http.Response r) {
    try {
      final m = (jsonDecode(r.body) as Map<String, dynamic>)['message'];
      if (m is String) return Exception(m);
      if (m is List && m.isNotEmpty) return Exception(m.first.toString());
    } catch (_) {}
    return Exception('Error ${r.statusCode}');
  }
}
