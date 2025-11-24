import 'package:client/features/cart/controller/cart_provider.dart';
import 'package:client/features/cart/controller/voice_cart_controller.dart';
import 'package:client/features/cart/view/payment_form_screen.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black),
        ),
        title: Text(
          '🛒 Carrito de Compras',
          style: AppTextStyle.withColor(
              AppTextStyle.h3, isDark ? Colors.white : Colors.black),
        ),
      ),

      // 🧺 Contenido principal
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Tu carrito está vacío 🛍️',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final width = constraints.maxWidth;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[900]
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black26
                                : Colors.grey.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🖼 Imagen del producto
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.product.urlImage,
                              width: width * 0.22,
                              height: width * 0.22,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 🧾 Información del producto
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.withColor(
                                    AppTextStyle.bodyLarge,
                                    isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${item.product.price} x ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total: \$${item.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ➕➖ Botones de cantidad + eliminar
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                        cart.notifyListeners();
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 24),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      item.quantity++;
                                      cart.notifyListeners();
                                    },
                                    icon: const Icon(Icons.add_circle_outline,
                                        size: 24),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () =>
                                    cart.removeFromCart(item.product),
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 💰 Sección de total + pagar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final items = cart.items
                                .map((item) => {
                                      'productId': item.product.id,
                                      'quantity': item.quantity,
                                      'subtotal': item.product.price *
                                          item.quantity,
                                    })
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentFormScreen(
                                  items: items,
                                  total: cart.totalPrice,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.payment, color: Colors.white),
                          label: const Text(
                            'Pagar ahora',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // 🎙 Micrófono (voz)
      floatingActionButton: const VoiceCartController(),
    );
  }
}
