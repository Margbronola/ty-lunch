import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/menu_details.dart';

class MenuViewModel {
  MenuViewModel._pr();
  static final MenuViewModel _instance = MenuViewModel._pr();
  static MenuViewModel get instance => _instance;
  final BehaviorSubject<List<MenuDetailsModel>> _subject =
      BehaviorSubject<List<MenuDetailsModel>>();
  Stream<List<MenuDetailsModel>> get stream => _subject.stream;
  List<MenuDetailsModel> get current => _subject.value;

  // static final WeeklyMenu _weekly = WeeklyMenu.instance;
  void populate(List<MenuDetailsModel> data) {
    // populateWeekly(data);
    _subject.add(data);
  }

  // void populateWeekly(List<MenuModel> data){
  //   final List<WeeklyMenuModel> ff =[];
  //   for(MenuModel menu in data){
  //     for(ScheduleModel sched in menu.schedule){
  //       ff.add(WeeklyMenuModel.fromMenu(menu, sched));
  //     }
  //   }
  //   ff.sort((a,b){
  //     return a.schedule.schedule.compareTo(b.schedule.schedule);
  //   });
  //   _weekly.populate(ff);
  // }
}
