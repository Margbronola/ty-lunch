class PaymentModel {
  final int id;
  final String reference;
  final String note;
  final double amount;
  final String paymentmethod;
  final DateTime date;

  const PaymentModel({
    required this.id,
    required this.reference,
    required this.note,
    required this.amount,
    required this.paymentmethod,
    required this.date,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      reference: json['reference'],
      note: json['note'],
      amount: json['amount'].toDouble(),
      paymentmethod: json['payment_method'],
      date: DateTime.parse(json['date']),
    );
  }
}
