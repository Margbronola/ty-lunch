import 'package:rxdart/subjects.dart';
import '../model/product_regroup.dart';

class ProductRegroupViewModel {
  ProductRegroupViewModel._pr();
  static final ProductRegroupViewModel _instance =
      ProductRegroupViewModel._pr();
  static ProductRegroupViewModel get instance => _instance;
  final BehaviorSubject<List<ProductRegroupModel>> _subject =
      BehaviorSubject<List<ProductRegroupModel>>();
  Stream<List<ProductRegroupModel>> get stream => _subject.stream;
  List<ProductRegroupModel> get current => _subject.value;

  void populate(List<ProductRegroupModel> payment) {
    _subject.add(payment);
  }
}
