import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:client/features/auth/service/http_client.dart';
import 'dart:convert';

class PaymentFormScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double total;

  const PaymentFormScreen({
    super.key,
    required this.items,
    required this.total,
  });

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {
  CardFieldInputDetails? _card;
  bool _loading = false;

  final emailController = TextEditingController();

  Future<void> _handlePayment() async {
    if (_card == null || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa los campos')),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      // 1️⃣ Crear PaymentIntent desde tu backend NestJS
      final response = await HttpClient.post('/api/v1/payment/payment-intent', {
        'items': widget.items,
      });
print(' consolaaaaaaaaaaaaaaaaaa Stripe backend response: ${response.body}');
      final data = jsonDecode(response.body);
      final clientSecret = data['clientSecret'];
      if (clientSecret == null) throw Exception("Error: no se recibió el clientSecret");

      // 2️⃣ Confirmar el pago con los datos de tarjeta ingresados
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              email: emailController.text,
            ),
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pago realizado exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error en el pago: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Pago'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Icon(Icons.credit_card, size: 60, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                "Total a pagar: \$${widget.total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // 📨 Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 💳 Campo de tarjeta de Stripe
              CardField(
                onCardChanged: (card) => setState(() => _card = card),
                decoration: InputDecoration(
                  labelText: "Información de la tarjeta",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 24),

              // 🔘 Botón de pago
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handlePayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Pagar ahora",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
