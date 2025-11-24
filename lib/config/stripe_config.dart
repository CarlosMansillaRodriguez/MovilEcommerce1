import 'package:flutter_stripe/flutter_stripe.dart';

class StripeConfig {
  static void init() {
    Stripe.publishableKey =
        "pk_test_51RFlZMR2ZVCoHvBxzAoQxIcnR9ki9AG8ZkFc5Zo3AIXYKzHFPtvcFzJ6H8fUcBBDDJeXwJMgDDJZ2aQKbl659PJy00EmZG3GbP"; // 🔑 tu clave pública de Stripe
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
  }
}
