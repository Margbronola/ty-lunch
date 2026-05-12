import 'package:tylunch/model/items.dart';
import 'package:tylunch/model/payment.dart';

class OrderHistoryModel {
  final int id;
  final String reference;
  final String commande;
  final DateTime date;
  final int clientid;
  final double total;
  final double subtotal;
  final double vat;
  final DateTime createdAt;
  final List<ItemsModel> items;
  final List<PaymentModel> payments;

  const OrderHistoryModel({
    required this.id,
    required this.reference,
    required this.commande,
    required this.date,
    required this.clientid,
    required this.total,
    required this.subtotal,
    required this.vat,
    required this.createdAt,
    required this.items,
    required this.payments,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    final List items = json['items'] ?? [];
    final List payments = json['payments'] ?? [];

    return OrderHistoryModel(
      id: json['id'],
      reference: json['reference'],
      commande: json['commande'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
      clientid: json['client_id'],
      total: json['total'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
      vat: json['vat'].toDouble(),
      items: items.map((e) => ItemsModel.fromJson(e)).toList(),
      payments: payments.map((e) => PaymentModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'date': date, 'items': items};

  @override
  String toString() => "${toJson()}";
}
