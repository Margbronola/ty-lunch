class CategoryModel {
  final int id;
  final String name;
  final double price;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'], name: json['name'], price: json['price'].toDouble());
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price.toString(),
        "name": name,
      };

  @override
  String toString() => "${toJson()}";
}
