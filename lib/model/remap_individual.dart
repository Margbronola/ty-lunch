class RemapIndividualModel {
  final String date;
  final int prodId;
  final int qty;
  final double price;
  final double total;
  final int menuId;
  final int categoryId;

  const RemapIndividualModel({
    required this.categoryId,
    required this.date,
    required this.menuId,
    required this.price,
    required this.prodId,
    required this.qty,
    required this.total,
  });

  factory RemapIndividualModel.fromJson(Map<String, dynamic> json) {
    return RemapIndividualModel(
      categoryId: int.parse(json['category_id'].toString()),
      date: json['date'],
      menuId: int.parse(json['menu_id'].toString()),
      price: json['unit_price'].toDouble(),
      prodId: int.parse(json['product_id'].toString()),
      qty: int.parse(json['quantity'].toString()),
      total: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "date": date,
        "menu_id": menuId,
        "unit_price": price,
        "product_id": prodId,
        "quantity": qty,
        "amount": total,
      };

  @override
  String toString() => "${toJson()}";
}
