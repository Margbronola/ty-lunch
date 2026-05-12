import 'package:rxdart/rxdart.dart';

import '../model/weeklymenu.dart';

class WeekdaysViewModel {
  WeekdaysViewModel._pr();
  static final WeekdaysViewModel _instance = WeekdaysViewModel._pr();
  static WeekdaysViewModel get instance => _instance;
  final BehaviorSubject<WeeklyMenuModel> _subject =
      BehaviorSubject<WeeklyMenuModel>();
  Stream<WeeklyMenuModel> get stream => _subject.stream;
  WeeklyMenuModel get current => _subject.value;

  void populate(WeeklyMenuModel data) {
    _subject.add(data);
  }
}
