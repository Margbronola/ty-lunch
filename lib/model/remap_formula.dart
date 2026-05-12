import 'categories.dart';

class RemapFormulaModel {
  final String date;
  final int formulaId;
  final int qty;
  final double unitPrice;
  final double amount;
  final List<CategoriesModel> categories;

  const RemapFormulaModel({
    required this.amount,
    required this.date,
    required this.formulaId,
    required this.qty,
    required this.unitPrice,
    required this.categories,
  });

  factory RemapFormulaModel.fromJson(Map<String, dynamic> json) {
    final List category = json['categories'] ?? [];

    return RemapFormulaModel(
      amount: json['amount'].toDouble(),
      date: json['date'],
      formulaId: json['formula_id'],
      qty: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      categories: category.map((e) => CategoriesModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "quantity": qty.toString(),
        "unit_price": unitPrice.toString(),
        "amount": amount.toString(),
        "formula_id": formulaId,
        "date": date,
        "categories": categories.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "${toJson()}";
}
