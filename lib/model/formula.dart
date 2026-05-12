import 'package:tylunch/model/menu_details.dart';

class FormulaModel {
  final int id;
  final String name;
  final double price;
  final String fullCategory;
  final List<CategorizedData> categories;

  const FormulaModel({
    required this.id,
    required this.name,
    required this.price,
    required this.fullCategory,
    required this.categories,
  });

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    final List categories = json['categories'] ?? [];
    return FormulaModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      fullCategory: json['fullcategory'],
      categories: categories
          .map(
            (e) => CategorizedData.fromJson(e),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price.toString(),
        "fullcategory": fullCategory,
        "categories": categories.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "${toJson()}";
}
