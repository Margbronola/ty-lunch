import 'package:tylunch/model/product.dart';

class MenuDetailsModel {
  final int id;
  final String name;
  final int status;
  final int isCleared;
  final List<CategorizedData> categories;

  const MenuDetailsModel({
    required this.id,
    required this.name,
    required this.status,
    required this.isCleared,
    required this.categories,
  });

  factory MenuDetailsModel.convert(Map<String, dynamic> json) {
    final Map<String, dynamic> categories = json['categories'];
    return MenuDetailsModel(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        isCleared: json['is_cleared'],
        categories: categories.entries
            .map((e) => CategorizedData.fromKeyVal(e))
            .toList());
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "is_cleared": isCleared,
        "categories": categories.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "${toJson()}";
}

class CategorizedData {
  final String name;
  final List<ProductModel> products;

  const CategorizedData({required this.name, required this.products});

  factory CategorizedData.fromKeyVal(MapEntry keymap) {
    final List products = keymap.value;
    return CategorizedData(
      name: keymap.key,
      products: products.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  factory CategorizedData.fromJson(Map<String, dynamic> json) {
    List products = [];
    if (json['product'] != null) {
      final dynamic prodVal = json['product'];
      if (prodVal.runtimeType is List) {
        products = prodVal;
      } else {
        products.add(prodVal);
      }
    }
    return CategorizedData(
      name: json['category']?['name'] ?? "UNNAMED PRODUCT",
      products: products.map((e) => ProductModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "products": products.map((e) => e.toJson()).toList()};

  @override
  String toString() => "${toJson()}";
}
