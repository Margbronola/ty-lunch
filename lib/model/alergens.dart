class AllergenModel {
  final int id;
  final String name;

  const AllergenModel({
    required this.id,
    required this.name,
  });

  factory AllergenModel.fromJson(Map<String, dynamic> json) {
    return AllergenModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name.toString(),
      };

  @override
  String toString() => "${toJson()}";
}
