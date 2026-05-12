import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/orderhistory.dart';

class OrderHistoryViewModel{
  OrderHistoryViewModel._pr();
  static final OrderHistoryViewModel _instance = OrderHistoryViewModel._pr();
  static OrderHistoryViewModel get instance => _instance;
  final BehaviorSubject<List<OrderHistoryModel>> _subject = BehaviorSubject<List<OrderHistoryModel>>();
  Stream<List<OrderHistoryModel>> get stream => _subject.stream;
  List<OrderHistoryModel> get current => _subject.value;

  void populate(List<OrderHistoryModel> data){
    _subject.add(data);
  }
}