class Env {
  // Puedes pasar --dart-define=URL_BACK=... en el build/run
  static const String apiBase =
      String.fromEnvironment('URL_BACK', defaultValue: 'https://backend-ecommerce-production-0ef1.up.railway.app');
}
