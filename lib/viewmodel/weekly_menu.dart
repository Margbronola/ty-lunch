import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/weeklymenu.dart';

class WeeklyMenuViewModel {
  WeeklyMenuViewModel._pr();
  static final WeeklyMenuViewModel _instance = WeeklyMenuViewModel._pr();
  static WeeklyMenuViewModel get instance => _instance;
  final BehaviorSubject<WeeklyMenuModel> _subject =
      BehaviorSubject<WeeklyMenuModel>();
  Stream<WeeklyMenuModel> get stream => _subject.stream;
  WeeklyMenuModel get current => _subject.value;

  void populate(WeeklyMenuModel data) {
    _subject.add(data);
  }
}
