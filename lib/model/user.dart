import 'package:tylunch/model/company.dart';

class UserModel {
  final int id;
  final String code;
  String email;
  String name;
  String lastname;
  final String? telephone;
  final String? gender;
  final DateTime? birthday;
  final CompanyModel company;
  final double? points;
  final int? month;
  final int? year;

  UserModel(
      {required this.id,
      required this.code,
      required this.email,
      required this.name,
      required this.lastname,
      this.telephone,
      this.gender,
      this.birthday,
      required this.company,
      this.points,
      this.month,
      this.year});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      code: json['code'],
      email: json['email'],
      name: json['name'],
      lastname: json['lastname'],
      telephone: json['telephone'],
      gender: json['gender'],
      birthday:
          json['birthday'] == null ? null : DateTime.parse(json['birthday']),
      company: CompanyModel.fromJson(json['company']),
      points: json['points'].toDouble(),
      month: json['birth_month'] == null ? null : json['birth_month'].toInt(),
      year: json['birth_year'] == null ? null : json['birth_year'].toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "email": email,
        "name": name,
        "lastname": lastname,
        "telephone": telephone,
        "gender": gender,
        "birthday": birthday?.toString(),
        "company": company,
        "points": points,
        "birth_year": year,
        "birth_month": month
      };

  @override
  String toString() => "${toJson()}";
}
