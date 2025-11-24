import 'package:client/controllers/auth_controller.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/auth/view/singin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingItem> _items = [
    OnboardingItem(
      description:
          'Descubre los electrodomésticos más innovadores para tu hogar moderno.',
      title: 'Explora lo Último en Tecnología',
      image: 'assets/images/intro.png',
    ),
    OnboardingItem(
      description: 'Accede a productos premium de marcas tecnológicas líderes, desde tu celular o PC..',
      title: 'Compra Inteligente y Segura',
      image: 'assets/images/intro1.png',
    ),
    OnboardingItem(
      description: 'Realiza tus compras de manera rápida, simple y desde cualquier lugar..',
      title: 'Tecnología al Alcance de un Clic',
      image: 'assets/images/intro2.png',
    ),
  ];

//   _handleGetStarted(); get started button pressed 
// handle get started button pressed
void _handleGetStarted() {
  final AuthController authController = Get.find<AuthController>();
  authController.setFirstTimeDone();
  Get.off(() =>  SigninScreen());
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _items[index].image,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  // Image.asset
                  //sizbox
                  const SizedBox(height: 40),
                  Text(
                    _items[index].title, // image
                    textAlign: TextAlign.center,
                    style: AppTextStyle.withColor(
                      AppTextStyle.h1,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  // Text
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _items[index].description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.withColor(
                        AppTextStyle.bodyLarge,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ),
                  ),

                  // Text
                ],
              );
            },
          ),

          // PageView.builder
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () =>   _handleGetStarted(),
                  child: Text(
                    "comenzar",
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ), // TextButton

                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _items.length - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // acción cuando termina el onboarding
                      _handleGetStarted();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), // RoundedRectangleBorder
                  ),
                  child: Text(
                    _currentPage < _items.length - 1 ? 'Siguiente' : 'Comenzar',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ), // Text
                ), // ElevatedButton
              ],
            ), // Row
          ), // Positioned
        ],
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.description,
    required this.title,
    required this.image,
  });
}
