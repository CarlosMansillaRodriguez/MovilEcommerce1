import 'dart:convert';
import 'package:client/Api/env.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class HttpClient {
  HttpClient._();
  static final _box = GetStorage();

  static Map<String, String> _headers({Map<String, String>? extra}) {
    final token = _box.read<String>('token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  static Uri _uri(String path) => Uri.parse('${Env.apiBase}$path');

  static Future<http.Response> get(String path) =>
      http.get(_uri(path), headers: _headers());

  static Future<http.Response> post(String path, Map body) =>
      http.post(_uri(path), headers: _headers(), body: jsonEncode(body));

  static Future<http.Response> patch(String path, Map body) =>
      http.patch(_uri(path), headers: _headers(), body: jsonEncode(body));

  static Future<http.Response> delete(String path) =>
      http.delete(_uri(path), headers: _headers());
}
