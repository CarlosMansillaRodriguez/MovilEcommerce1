import 'package:client/controllers/theme_controller.dart';
import 'package:client/features/product/view/all_product_screen.dart';
import 'package:client/features/cart/view/cart_screen.dart';
import 'package:client/features/product/view/category_chips.dart';
import 'package:client/features/widgets/custom_search_bar.dart';
import 'package:client/features/product/view/product_grid.dart';
import 'package:client/features/prmociones/sale_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // header section
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido Alex',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      // Text
                      Text(
                        'Buenos Dias',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  // Column
                  const Spacer(),

                  // notification icon
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                    // Icon
                  ),

                  // IconButton
                  // cart button
                  IconButton(
                    onPressed: () => Get.to(() => const CartScreen()),

                    icon: const Icon(Icons.shopping_cart_outlined),
                    // Icon
                  ),
                  // theme  button
                  // theme button
                  GetBuilder<ThemeController>(
                    builder: (controller) => IconButton(
                      onPressed: () => controller.toggleTheme(),
                      icon: Icon(
                        controller.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      // Icon
                    ),
                    // IconButton
                  ),

                  // GetBuilder
                ],
              ),
            ),
            // Padding

            ///   search bar
            const CustomSearchBar(),

            // category chips
            const CategoryChips(),

            // sale banner
            const SaleBanner(),

            // popular product
            // popular product
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Productos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  GestureDetector(
                    onTap: ()=> Get.to(()=>const  AllProductsScreen()),
                    child: Text(
                      'Ver todo ' ,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),

            // producto  grid
            const Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }
}
