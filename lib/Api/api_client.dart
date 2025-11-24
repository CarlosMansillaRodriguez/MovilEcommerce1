import 'dart:convert';
import 'package:http/http.dart' as http;

/// Usa --dart-define=URL_BACK=https://backend-ecommerce-production-9be2.up.railway.app
const String kBaseUrl = String.fromEnvironment(
  'URL_BACK',
  defaultValue: 'https://backend-ecommerce-production-0ef1.up.railway.app',
);

Uri _u(String path, [Map<String, dynamic>? q]) =>
    Uri.parse('$kBaseUrl$path').replace(queryParameters: q);

class ApiClient {
  final http.Client _c;
  ApiClient({http.Client? client}) : _c = client ?? http.Client();

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await _c.get(_u(path, query));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('GET $path → ${res.statusCode} ${res.body}');
    }
    return json.decode(utf8.decode(res.bodyBytes));
  }
}
