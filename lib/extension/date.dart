extension CHECKER on DateTime {
  bool isSameDate(DateTime comp) => day == comp.day && month == comp.month && year == comp.year;
}