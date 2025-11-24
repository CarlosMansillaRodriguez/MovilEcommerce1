import 'package:get/get.dart';
import '../service/favorito_api.dart';

class FavoritoController extends GetxController {
  var favoritos = <Map<String, dynamic>>[].obs;
  var loading = false.obs;

  /// 🔹 Cargar favoritos del usuario
  Future<void> loadFavoritos() async {
    try {
      loading.value = true;
      favoritos.value = await FavoritoApi.listFavoritos();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      loading.value = false;
    }
  }

  /// 🔹 Agregar producto a favoritos
  Future<void> addFavorito(int productoId) async {
    try {
      await FavoritoApi.addToFavoritos(productoId);
      await loadFavoritos(); // actualiza lista
      Get.snackbar('Éxito', 'Producto agregado a favoritos');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// 🔹 Eliminar producto de favoritos
  Future<void> removeFavorito(int productoId) async {
    try {
      await FavoritoApi.removeFromFavoritos(productoId);
      favoritos.removeWhere(
          (f) => f['producto'] != null && f['producto']['id'] == productoId);
      Get.snackbar('Eliminado', 'Producto eliminado de favoritos');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// 🔹 Verificar si un producto está en favoritos
  bool isFavorito(int productoId) {
    return favoritos
        .any((f) => f['producto'] != null && f['producto']['id'] == productoId);
  }
}
