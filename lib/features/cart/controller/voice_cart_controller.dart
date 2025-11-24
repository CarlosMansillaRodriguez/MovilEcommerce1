import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:client/features/product/models/product_model.dart';
import '../controller/cart_provider.dart';
import 'package:get_storage/get_storage.dart';
class VoiceCartController extends StatefulWidget {
  const VoiceCartController({super.key});

  @override
  State<VoiceCartController> createState() => _VoiceCartControllerState();
}

class _VoiceCartControllerState extends State<VoiceCartController> {
  late stt.SpeechToText _speech;
  final FlutterTts _tts = FlutterTts();
  bool _listening = false;
  String _command = "";

  final String _baseUrl =
      'https://backend-ecommerce-production-0ef1.up.railway.app/api/v1';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _listen(BuildContext context) async {
    if (!_listening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _listening = true);
        _speech.listen(
          onResult: (result) {
            setState(() => _command = result.recognizedWords);
            _interpretCommand(context, _command);
          },
          localeId: 'es_ES', // o es_BO
        );
      }
    } else {
      setState(() => _listening = false);
      _speech.stop();
    }
  }

Future<void> _interpretCommand(BuildContext context, String command) async {
  final cart = Provider.of<CartProvider>(context, listen: false);
  final lower = command.toLowerCase();

  // 🔁 Normalizamos las palabras clave (añadir/agregar/meter)
  if (lower.contains("agregar") || lower.contains("añadir") || lower.contains("meter")) {
    await _addProductByVoice(context, lower, cart);
  } else if (lower.contains("eliminar") || lower.contains("vaciar")) {
    cart.clearCart();
    await _tts.speak("Carrito vaciado");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑️ Carrito vaciado")),
    );
  } else if (lower.contains("pagar") || lower.contains("comprar")) {
    await _tts.speak("Iniciando proceso de pago");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("💳 Iniciando proceso de pago...")),
    );
  } else {
    // Evita repetir fragmentos parciales
    if (lower.trim().split(' ').length < 3) return;
    await _tts.speak("No entendí el comando");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Comando no reconocido: $command")),
    );
  }
}


  Future<void> _addProductByVoice(
      BuildContext context, String command, CartProvider cart) async {
    try {
final box = GetStorage();
final token = box.read<String>('token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ No se encontró el token de sesión")),
        );
        return;
      }

      // 🔍 Extraer nombre de producto después de la palabra “agregar”
      final productName =
          command.replaceAll("agregar", "").replaceAll("al carrito", "").trim();

      final url = Uri.parse("$_baseUrl/product");
      final res = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final productJson = data.firstWhere(
          (p) => p['name'].toString().toLowerCase().contains(productName),
          orElse: () => null,
        );

        if (productJson == null) {
          await _tts.speak("No encontré el producto $productName");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("❌ No se encontró el producto: $productName")),
          );
          return;
        }
final product = ProductModel(
  id: productJson['id'],
  name: productJson['name'],
  description: productJson['description'] ?? '', // 👈 obligatorio
  price: double.parse(productJson['price'].toString()),
  urlImage: productJson['urlImage'],
);


        cart.addToCart(product);
        await _tts.speak("Se agregó ${product.name} al carrito");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📦 ${product.name} agregado al carrito")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al obtener productos: ${res.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurple,
      onPressed: () => _listen(context),
      child: Icon(_listening ? Icons.mic_off : Icons.mic),
    );
  }
}
