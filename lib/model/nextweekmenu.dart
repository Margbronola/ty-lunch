class NextWeekMenuModel {
  final String now;
  final bool showNextWeekMenus;
  final String nextWeekMonday;

  const NextWeekMenuModel({
    required this.nextWeekMonday,
    required this.now,
    required this.showNextWeekMenus,
  });

  factory NextWeekMenuModel.fromJson(Map<String, dynamic> json) {
    return NextWeekMenuModel(
      nextWeekMonday: json['next_week_monday'],
      now: json['now'],
      showNextWeekMenus: json['show_next_week_menus'],
    );
  }

  Map<String, dynamic> toJson() => {
        "next_week_monday": nextWeekMonday,
        "now": now,
        "show_next_week_menus": showNextWeekMenus,
      };

  @override
  String toString() => "${toJson()}";
}
