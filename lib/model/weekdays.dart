import 'menu.dart';

class WeekdaysModel {
  final String? key;
  final List<MenuModel>? menu;

  const WeekdaysModel({
    required this.key,
    required this.menu,
  });

  factory WeekdaysModel.fromKeyVal(MapEntry keymap) {
    final List menus = keymap.value;
    return WeekdaysModel(
      key: keymap.key,
      menu: menus.map((e) => MenuModel.fromJson(e)).toList(),
    );
  }

  factory WeekdaysModel.fromJson(Map<String, dynamic> json) {
    List menus = [];
    if (json['menu'] != null) {
      final dynamic menuVal = json['menu'];
      if (menuVal.runtimeType is List) {
        menus = menuVal;
      } else {
        menus.add(menuVal);
      }
    }
    return WeekdaysModel(
      key: json['key'],
      menu: menus.map((e) => MenuModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      {"name": key, "menu": menu!.map((e) => e.toJson()).toList()};

  @override
  String toString() => "${toJson()}";
}
