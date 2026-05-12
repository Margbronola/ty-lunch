import 'item.dart';

class NewCart1Model {
  final int id;
  final double subTotal;
  final String? paymentMethod;
  final int usePackaging;
  final int clientId;
  final List<ItemModel> items;

  NewCart1Model({
    required this.id,
    required this.subTotal,
    required this.paymentMethod,
    required this.usePackaging,
    required this.clientId,
    required this.items,
  });

  factory NewCart1Model.fromJson(Map<String, dynamic> json) {
    final List item = json['items'];

    return NewCart1Model(
      id: json['id'],
      subTotal: json['subTotal'].toDouble(),
      paymentMethod: json['paymentMethod'],
      clientId: json['clientId'],
      usePackaging: json['use_packaging'],
      items: item.map((e) => ItemModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "subtotal": subTotal,
        "client_id": clientId,
        "use_packaging": usePackaging,
        "payment_method": paymentMethod,
        "items": items.map((e) => e).toList(),
      };

  @override
  String toString() => "${toJson()}";
}
