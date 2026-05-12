import 'package:tylunch/model/menu_details.dart';

class MenuModel {
  final int id;
  final int menuID;
  final String schedule;
  final MenuDetailsModel details;

  const MenuModel(
      {required this.details,
      required this.id,
      required this.menuID,
      required this.schedule});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      details: MenuDetailsModel.convert(json['menu']),
      id: json['id'],
      menuID: json['menu_id'],
      schedule: json['schedule'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "menu_id": menuID,
        "schedule": schedule,
        "menu": details,
      };

  @override
  String toString() => "${toJson()}";
}
