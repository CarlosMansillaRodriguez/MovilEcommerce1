import 'package:get/get.dart';
import '../controller/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // Usamos lazyPut para que solo se cree cuando se necesite
    Get.lazyPut(() => ProductController());
  }
}
