import 'package:client/features/cart/view/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_chips.dart';
import 'product_grid.dart';
import '../controller/product_controller.dart';
import 'package:client/utils/app_textstyles.dart';
import '../widget/filter_botton_sheet.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController()); // Inyecta el controlador

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tienda',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          IconButton(
            onPressed: () => FilterBottomSheet.show(context),
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          /// 🛒 Ícono para ir al carrito
          IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),

      body: const Column(
        children: [
          SizedBox(height: 12),
          CategoryChips(),
          Expanded(child: ProductGrid()),
        ],
      ),
    );
  }
}
