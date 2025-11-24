import 'dart:convert';
import 'package:client/features/auth/service/http_client.dart';
import 'package:http/http.dart' as http;

class FavoritoApi {
  /// 📌 Agrega un producto a favoritos (POST /favoritos/:productoId)
  static Future<Map<String, dynamic>> addToFavoritos(int productoId) async {
    final http.Response res = await HttpClient.post('/api/v1/favoritos/$productoId', {});

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw _handleError(res);
    }
  }

  /// 📌 Lista los productos favoritos del usuario autenticado (GET /favoritos)
  static Future<List<Map<String, dynamic>>> listFavoritos() async {
    final http.Response res = await HttpClient.get('/api/v1/favoritos');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw _handleError(res);
    }
  }

  /// 📌 Elimina un producto de favoritos (DELETE /favoritos/:productoId)
  static Future<Map<String, dynamic>> removeFromFavoritos(int productoId) async {
    final http.Response res = await HttpClient.delete('/favoritos/$productoId');

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw _handleError(res);
    }
  }

  /// 🔒 Manejo de errores
  static Exception _handleError(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      final msg = decoded['message'] ?? 'Error desconocido';
      return Exception(msg);
    } catch (_) {
      return Exception('Error ${res.statusCode}');
    }
  }
}
