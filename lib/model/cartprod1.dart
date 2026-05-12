class CartProduct1 {
  final String date;
  final int productId;
  final int qty;
  final double unitPrice;
  final double amount;
  final int menuId;
  final int categoryId;

  CartProduct1({
    required this.productId,
    required this.amount,
    required this.date,
    required this.qty,
    required this.unitPrice,
    required this.menuId,
    required this.categoryId,
  });

  factory CartProduct1.fromJson(Map<String, dynamic> json) {
    return CartProduct1(
      date: json['date'],
      productId: json['product_id'],
      qty: json['quantity'],
      amount: json['unit_price'].toDouble(),
      unitPrice: json['amount'].toDouble(),
      menuId: json['menu_id'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": productId.toString(),
        "quantity": qty.toString(),
        "unit_price": unitPrice.toString(),
        "amount": amount.toString(),
        "date": date,
        "menuId": menuId,
        "categoryId": categoryId,
      };

  @override
  String toString() => "${toJson()}";
}
