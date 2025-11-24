import 'package:client/controllers/auth_controller.dart';
import 'package:client/features/auth/models/user.dart';
import 'package:client/features/driver/driver_home.dart';
import 'package:client/main/main_screen.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/auth/view/forgot_password_screen.dart';
import 'package:client/features/auth/view/sign_up_screen.dart';
import 'package:client/features/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                '¡Bienvenido de nuevo!',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para continuar con tus compras.',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 32),

              /// Email
              CustomTextfield(
                label: 'Correo electrónico',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// Password
              CustomTextfield(
                label: 'Contraseña',
                prefixIcon: Icons.lock_open_outlined,
                controller: _passwordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu contraseña';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              /// Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /// Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes una cuenta?",
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => SignUpScreen()),
                    child: Text(
                      'Regístrate',
                      style: AppTextStyle.withColor(
                        AppTextStyle.buttonMedium,
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _handleSignIn() async {
  final email = _emailController.text.trim();
  final pass  = _passwordController.text.trim();
  if (email.isEmpty || pass.isEmpty) {
    Get.snackbar('Error', 'Completa email y contraseña');
    return;
  }

  final auth = Get.find<AuthController>();
  try {
    final authResponse = await auth.login(email, pass);
    final user = authResponse.user;
    if (user.rolId == 3) {
      // 🚚 Si es chofer
      Get.offAll(() => const DriverHome());
    } else {
      // 🛒 Si es cliente
      Get.offAll(() => const MainScreen());
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
  }
}

}
