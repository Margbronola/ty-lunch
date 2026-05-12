class ReserveModel {
  final int id;
  final String reference;
  final String prefix;
  final int year;
  final int month;

  const ReserveModel({
    required this.id,
    required this.month,
    required this.prefix,
    required this.reference,
    required this.year,
  });

  factory ReserveModel.fromJson(Map<String, dynamic> json) {
    return ReserveModel(
      id: json['id'],
      month: json['month'],
      prefix: json['prefix'],
      reference: json['reference'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "month": month,
        "prefix": prefix,
        "reference": reference,
        "year": year,
      };

  @override
  String toString() => "${toJson()}";
}
