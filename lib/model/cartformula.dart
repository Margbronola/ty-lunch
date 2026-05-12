import 'categories.dart';

class CartFormula {
  final String date;
  final int formulaId;
  final int qty;
  final double unitPrice;
  final double amount;
  final List<CategoriesModel> categories;

  const CartFormula({
    required this.amount,
    required this.categories,
    required this.date,
    required this.formulaId,
    required this.qty,
    required this.unitPrice,
  });

  factory CartFormula.fromJson(Map<String, dynamic> json) {
    final List category = json['categories'] ?? [];
    return CartFormula(
      amount: json['amount'].toDouble(),
      categories: category.map((e) => CategoriesModel.fromJson(e)).toList(),
      date: json['date'],
      formulaId: json['formula_id'],
      qty: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'amount': amount.toString(),
        'date': date,
        'formula_id': formulaId,
        'quantity': qty,
        'unit_price': unitPrice,
        'categories': categories.map((e) => e.toJson()).toList()
      };

  @override
  String toString() => "${toJson()}";
}
