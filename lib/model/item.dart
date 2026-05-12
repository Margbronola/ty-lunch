import 'package:tylunch/model/cartformula.dart';
import 'package:tylunch/model/cartprod1.dart';

class ItemModel {
  final List<CartFormula> cartformula;
  final List<CartProduct1> cartproduct;

  const ItemModel({
    required this.cartformula,
    required this.cartproduct,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    final List formu = json['formula'] ?? [];
    final List prod = json['product'] ?? [];

    return ItemModel(
      cartformula: formu.map((e) => CartFormula.fromJson(e)).toList(),
      cartproduct: prod.map((e) => CartProduct1.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'formula': cartformula.map((e) => e.toJson()).toList(),
        'product': cartproduct.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "${toJson()}";
}
