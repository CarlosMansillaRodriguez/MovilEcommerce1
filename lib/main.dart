import 'package:client/controllers/auth_controller.dart';
import 'package:client/controllers/navegacion_controller.dart';
import 'package:client/controllers/theme_controller.dart';
import 'package:client/features/cart/controller/cart_provider.dart';
import 'package:client/features/favorites/controller/favorito_controller.dart';
import 'package:client/features/product/controller/product_controller.dart';
import 'package:client/features/splash/splash_screen.dart';
import 'package:client/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart'; // 👈 importa Stripe

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // 🧩 Inicializa Stripe ANTES de runApp()
  Stripe.publishableKey = "pk_test_51RFlZMR2ZVCoHvBxzAoQxIcnR9ki9AG8ZkFc5Zo3AIXYKzHFPtvcFzJ6H8fUcBBDDJeXwJMgDDJZ2aQKbl659PJy00EmZG3GbP"; // ⚠️ tu clave pública real
  Stripe.merchantIdentifier = 'merchant.shopealo.app';
  Stripe.urlScheme = 'flutterstripe'; // necesario para Android
  await Stripe.instance.applySettings();

  // Inicializa controladores GetX
  Get.put(ThemeController());
  Get.put(AuthController());
  Get.put(NavigationController());
  Get.put(ProductController());
  Get.put(FavoritoController());


  // Envuelve tu app en MultiProvider (para el carrito)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopealo Store',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      defaultTransition: Transition.fade,
      home: SplashScreen(),
    );
  }
}
