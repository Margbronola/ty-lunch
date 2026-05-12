class CartProduct {
  final int productId; //prodId sa database
  int quantity;
  final double price;
  late final double total;
  final String name;
  final String? image;
  final String? meals;
  final bool isFormula;
  final int day;
  final int menuId;
  final int categoryId;

  CartProduct({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.total,
    this.isFormula = false,
    this.meals,
    required this.name,
    this.image,
    required this.day,
    required this.menuId,
    required this.categoryId,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json,
      [bool isFormula = false]) {
    return CartProduct(
      productId: json['prodId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      total: json['total'].toDouble(),
      name: json['name'],
      image: json['image'],
      meals: json['meals'],
      day: json['day'],
      menuId: json['menuId'],
      categoryId: json['categoryId'],
      isFormula: isFormula,
    );
  }

  Map<String, dynamic> toJson() => {
        isFormula ? "formula_id" : "product_id": productId.toString(),
        "quantity": quantity.toString(),
        "price": price.toString(),
        "total": total.toString(),
        "name": name,
        "day": day,
        "menuId": menuId,
        "categoryId": categoryId,
      };

  @override
  String toString() => "${toJson()}";
}
