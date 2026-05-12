import 'package:rxdart/rxdart.dart';
import 'package:tylunch/model/product.dart';

class ProductViewModel {
  ProductViewModel._pr();
  static final ProductViewModel _instance = ProductViewModel._pr();
  static ProductViewModel get instance => _instance;
  final BehaviorSubject<List<ProductModel>> _subject =
      BehaviorSubject<List<ProductModel>>();
  Stream<List<ProductModel>> get stream => _subject.stream;
  List<ProductModel> get current => _subject.value;

  void populate(List<ProductModel> data) {
    _subject.add(data);
  }
}
