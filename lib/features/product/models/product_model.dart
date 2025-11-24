class CategoryModel {
  final int id;
  final String name;
  final String? description;

  CategoryModel({required this.id, required this.name, this.description});

  factory CategoryModel.fromJson(Map<String, dynamic> j) => CategoryModel(
    id: j['id'] as int,
    name: j['name'] as String,
    description: j['description'] as String?,
  );
}

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int? stock;
  final int? stockMinimo;
  final String urlImage;
  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.stock,
    this.stockMinimo,
    required this.urlImage,
    this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
    id: j['id'] as int,
    name: j['name'] as String,
    description: j['description'] as String? ?? '',
    price: double.tryParse(j['price'].toString()) ?? 0.0,
    stock: j['stock'] as int?,
    stockMinimo: j['stock_minimo'] as int?,
    urlImage: j['urlImage'] as String? ?? '',
    category: j['category'] != null
        ? CategoryModel.fromJson(j['category'])
        : null,
  );
}
