class CompanyModel {
  final int id;
  final String name;
  final String? fullDelivery;
  final String? contactName;
  final String? email;
  final String? telephone;
  final String? location;
  final String? deliveryLocation;
  final int deliveryType;

  const CompanyModel({
    required this.id,
    required this.name,
    this.fullDelivery,
    this.contactName,
    this.email,
    this.telephone,
    this.deliveryLocation,
    required this.deliveryType,
    this.location,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
        id: json['id'],
        name: json['name'],
        fullDelivery: json['full_delivery'],
        contactName: json['contact_name'],
        email: json['email'],
        telephone: json['telephone'],
        location: json['location'],
        deliveryLocation: json['delivery_location'],
        deliveryType: json['delivery_type']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "full_delivery": fullDelivery,
        "contact_name": contactName,
        "email": email,
        "telephone": telephone,
        "delivery_location": deliveryLocation,
        "delivery_type": deliveryType,
        "location": location,
      };

  @override
  String toString() => "${toJson()}";
}
