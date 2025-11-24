import 'package:client/features/product/models/product_model.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/product/widget/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:client/features/cart/controller/cart_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          'Detalles del producto',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                _shareProduct(context, product.name, product.description),
            icon: Icon(
              Icons.share,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= Imagen principal =======
            AspectRatio(
              aspectRatio: 16 / 9,
              child: product.urlImage.isNotEmpty
                  ? Image.network(
                      product.urlImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, size: 64),
                    ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======= Nombre + precio =======
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: AppTextStyle.withColor(
                            AppTextStyle.h2,
                            Theme.of(context).textTheme.headlineMedium!.color!,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: AppTextStyle.withColor(
                          AppTextStyle.h2,
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    product.category?.name ?? 'Sin categoría',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ======= Selector de talla (decorativo) =======
                  Text(
                    'Selecciona tamaño',
                    style: AppTextStyle.withColor(
                      AppTextStyle.labelMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizeSelector(),
                  const SizedBox(height: 20),

                  // ======= Descripción =======
                  Text(
                    'Descripción',
                    style: AppTextStyle.withColor(
                      AppTextStyle.labelMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'Sin descripción disponible.',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodySmall,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ======= BOTONES INFERIORES =======
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              // --- Botón: Añadir al carrito ---
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final cart =
                        Provider.of<CartProvider>(context, listen: false);
                    cart.addToCart(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} agregado al carrito'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    side: BorderSide(
                      color: isDark ? Colors.white70 : Colors.black12,
                    ),
                  ),
                  child: Text(
                    'Agregar al carrito',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                ),
              ),

              SizedBox(width: screenWidth * 0.04),

              // --- Botón: Comprar ahora ---
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Acción de compra inmediata
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    'Comprar ahora',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// === Función para compartir ===
  Future<void> _shareProduct(
      BuildContext context, String productName, String description) async {
    final box = context.findRenderObject() as RenderBox;
    const String shopLink = 'https://yourshop.com/product';
    final shareMessage = '$description\n\nCompra ahora en $shopLink';

    try {
      await Share.share(
        shareMessage,
        subject: productName,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      debugPrint('Error al compartir: $e');
    }
  }
}
