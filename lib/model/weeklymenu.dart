import 'package:tylunch/model/weekdays.dart';

class WeeklyMenuModel {
  final String? startdate;
  final String? endDate;
  final String? month;
  final List<WeekdaysModel>? menus;

  const WeeklyMenuModel(
      {required this.endDate,
      required this.month,
      required this.startdate,
      required this.menus});

  factory WeeklyMenuModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> menu = json["results"];
    return WeeklyMenuModel(
        endDate: json["end"],
        month: json["months"],
        startdate: json["start"],
        menus: menu.entries.map((e) => WeekdaysModel.fromKeyVal(e)).toList());
  }

  Map<String, dynamic> toJson() => {
        "end": endDate,
        "months": month,
        "start": startdate,
        "results": menus,
      };

  @override
  String toString() => "${toJson()}";
}
