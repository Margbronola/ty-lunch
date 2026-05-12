import 'package:tylunch/model/formula.dart';
import 'package:tylunch/model/product.dart';

class ItemsModel {
  final int id;
  final int qty;
  final double unitprice;
  final double amount;
  final ProductModel? product;
  final FormulaModel? formula;

  const ItemsModel({
    required this.id,
    required this.qty,
    required this.unitprice,
    required this.amount,
    this.product,
    this.formula,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
        id: json['id'],
        qty: json['quantity'],
        unitprice: json['unit_price'].toDouble(),
        amount: json['amount'].toDouble(),
        product: json['product'] == null
            ? null
            : ProductModel.fromJson(json['product']),
        formula: json['formula'] == null
            ? null
            : FormulaModel.fromJson(json['formula']));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": qty,
        "unit_price": unitprice,
        "amount": amount,
        "product": product,
        "formula": formula,
      };

  @override
  String toString() => "${toJson()}";
}
