import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProductController>();
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Ajusta columnas automáticamente según el tamaño de pantalla
    int crossAxisCount = 2;
    if (screenWidth > 1200) {
      crossAxisCount = 5;
    } else if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    return Obx(() {
      if (c.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final list = c.filtered;
      if (list.isEmpty) {
        return const Center(
          child: Text(
            'Sin productos disponibles 😢',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }

      // ✅ Diseño adaptable, con padding y transición visual
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GridView.builder(
          key: ValueKey(list.length),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 18,
            childAspectRatio: screenWidth < 400 ? 0.80 : 0.70,
          ),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ProductCard(product: list[i]),
            );
          },
        ),
      );
    });
  }
}
