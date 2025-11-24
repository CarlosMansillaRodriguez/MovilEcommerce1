import 'dart:convert';
import 'package:client/features/auth/service/http_client.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';

class PaymentService {
  /// Crear pago con Stripe usando tu backend NestJS
  static Future<void> payWithStripe(List<Map<String, dynamic>> items) async {
    try {
      // 1️⃣ Llamar al backend -> /payment/payment-intent
      final response = await HttpClient.post('/api/v1/payment/payment-intent', {
        'items': items,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error creando PaymentIntent: ${response.body}');
      }

      // 2️⃣ Decodificar la respuesta
      final data = jsonDecode(response.body);
      final clientSecret = data['clientSecret'];
      if (clientSecret == null) {
        throw Exception('No se recibió el clientSecret del backend');
      }

      // 3️⃣ Inicializar PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Shopealo',
          style: ThemeMode.system,
        ),
      );

      // 4️⃣ Mostrar PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // 5️⃣ (Opcional) Confirmar en backend si deseas registrar la orden
      // await HttpClient.post('/orders/confirm', { ... });
    } catch (e) {
      if (e is StripeException) {
        throw Exception('Pago cancelado o fallido: ${e.error.localizedMessage}');
      } else {
        throw Exception('Error en el proceso de pago: $e');
      }
    }
  }
}
