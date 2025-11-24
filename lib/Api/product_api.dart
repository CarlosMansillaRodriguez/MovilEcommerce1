 import 'package:client/api/api_client.dart';

import '../features/product/models/product_model.dart';

class ProductApi {
  final ApiClient _api;
  ProductApi(this._api);

  Future<List<ProductModel>> getProducts() async {
    final data = await _api.get('/api/v1/product');
    return (data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final data = await _api.get('/api/v1/category');
    return (data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }
}
 


