import 'package:get/get.dart';
import 'package:client/api/api_client.dart';
import '../../../Api/product_api.dart';
import '../models/product_model.dart';

/* cambios  */
class ProductController extends GetxController {
  final _api = ProductApi(ApiClient());

  final products = <ProductModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final loading = false.obs;
  final selectedCategoryId = Rxn<int>(); // null = todas

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    loading.value = true;
    try {
      final cats = await _api.getCategories();
      categories.assignAll(cats);

      final prods = await _api.getProducts();
      products.assignAll(prods);
    } finally {
      loading.value = false;
    }
  }

  List<ProductModel> get filtered {
    final id = selectedCategoryId.value;
    if (id == null) return products;
    return products.where((p) => p.category?.id == id).toList();
  }

  void selectCategory(int? id) {
    // asdasdasdas
    selectedCategoryId.value = id;
  }
}
