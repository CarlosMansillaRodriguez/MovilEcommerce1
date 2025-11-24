import 'package:client/controllers/navegacion_controller.dart';
import 'package:client/controllers/theme_controller.dart';
import 'package:client/features/auth/view/account_screen.dart';
import 'package:client/features/profile/home_screen.dart';
import 'package:client/features/product/view/shopping_screen.dart';
import 'package:client/features/widgets/custom_botton_navbar.dart';
import 'package:client/features/list_Favori/wishilist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /* final NavigationController navigationController = Get.put(
      NavigationController(), */
           final NavigationController navigationController =
        Get.find<NavigationController>()

  ;

    return GetBuilder<ThemeController>(
      builder: (themeController) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Obx(
            () => IndexedStack(
              key: ValueKey(navigationController.currentIndex.value),
              index: navigationController.currentIndex.value,
              children: const [
                HomeScreen(),
                ShoppingScreen(),
                WishlistScreen(),
                AccountScreen(),
              ],
            ),
          ),
        ),
        bottomNavigationBar : const CustomBottomNavbar()
      ),
    );
  }
}
