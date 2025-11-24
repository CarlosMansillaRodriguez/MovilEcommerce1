import 'package:client/features/auth/models/user.dart';
import 'package:client/utils/app_textstyles.dart';
import 'package:client/features/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

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
              // Botón de retroceso
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Restablecer contraseña',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Ingresa tu correo electrónico para restablecer tu contraseña.',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),

              const SizedBox(height: 40),

              /// Campo de correo
              CustomTextfield(
                label: 'Correo electrónico',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              /// Botón para enviar enlace
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();

                    // Creamos un usuario temporal con solo el email
                    final tempUser = User(
                      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
                      name: 'Desconocido',
                      email: email,
                    );

                    print('Usuario que solicita recuperación: ${tempUser.toJson()}');

                    showSuccessDialog(context, tempUser);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Enviar enlace',
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

  /// Diálogo de éxito personalizado con datos del usuario
  void showSuccessDialog(BuildContext context, User user) {
    Get.dialog(
      AlertDialog(
        title: Text('¡Revisa tu correo!', style: AppTextStyle.h3),
        content: Text(
          'Hemos enviado instrucciones a ${user.email} para restablecer tu contraseña.',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Aceptar',
              style: AppTextStyle.withColor(
                AppTextStyle.buttonMedium,
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
