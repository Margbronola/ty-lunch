import 'package:tylunch/model/cartprod.dart';

class NewCartModel {
  final int id;
  double subTotal;
  final DateTime date;
  final int clientId;
  final List<CartProduct> products;

  NewCartModel({
    required this.id,
    required this.subTotal,
    required this.date,
    required this.clientId,
    required this.products,
  });

  factory NewCartModel.fromJson(Map<String, dynamic> json) {
    final List prod = json['products'];
    return NewCartModel(
      id: json['id'],
      subTotal: json['subTotal'],
      date: json['date'],
      clientId: json['clientId'],
      products: prod.map((e) => CartProduct.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "subtotal": subTotal.toString(),
        "date": date.toString(),
        "client_id": clientId.toString(),
        "items": products.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => "${toJson()}";
}
