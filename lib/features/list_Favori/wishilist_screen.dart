import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/favorites/controller/favorito_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoritoController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🔹 Cargamos los favoritos al abrir la pantalla
    favController.loadFavoritos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos ❤️'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Obx(() {
        if (favController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (favController.favoritos.isEmpty) {
          return const Center(
            child: Text(
              'No tienes productos en favoritos 💔',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final favoritos = favController.favoritos;

        // 🧩 Muestra los productos favoritos
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: favoritos.length,
          itemBuilder: (context, index) {
            final producto = favoritos[index]['producto'];

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark ? Colors.black26 : Colors.grey.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Imagen ===
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: producto['urlImage'] ?? '',
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 40),
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),

                  // === Información ===
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto['name'] ?? 'Producto sin nombre',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.withColor(
                            AppTextStyle.h4,
                            Theme.of(context).textTheme.bodyLarge!.color!,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${producto['price']}',
                          style: AppTextStyle.withColor(
                            AppTextStyle.bodyLarge,
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 🗑️ Botón eliminar
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => favController
                                .removeFavorito(producto['id'] as int),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
