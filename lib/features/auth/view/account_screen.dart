import 'package:client/controllers/auth_controller.dart';
import 'package:client/features/auth/view/singin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mi Perfil"),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'No hay sesión activa.',
            style: TextStyle(color: textColor, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {
              Get.snackbar('Editar Perfil', 'Funcionalidad en desarrollo');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDatoItem(context, 'Correo:', user.email, Icons.email),
                    _buildDatoItem(context, 'Rol:', user.rolNombre, Icons.person_pin_circle),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🚪 BOTÓN CERRAR SESIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Limpia almacenamiento local y sesión
                  final box = GetStorage();
                  await box.erase(); // 🔥 Elimina token, usuario y todo

                  // Limpia estado del controlador
                  authController.logout();

                  // Redirige al login
             Get.offAll(() =>  SigninScreen());
                  Get.snackbar(
                    'Sesión cerrada',
                    'Has cerrado sesión correctamente',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatoItem(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color valueColor = isDark ? Colors.grey[300]! : Colors.grey[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
