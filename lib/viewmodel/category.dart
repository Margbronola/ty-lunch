import 'package:rxdart/rxdart.dart';

import '../model/category.dart';

class CategoryViewModel {
  CategoryViewModel._pr();
  static final CategoryViewModel _instance = CategoryViewModel._pr();
  static CategoryViewModel get instance => _instance;
  final BehaviorSubject<List<CategoryModel>> _subject =
      BehaviorSubject<List<CategoryModel>>();
  Stream<List<CategoryModel>> get stream => _subject.stream;
  List<CategoryModel> get current => _subject.value;

  void populate(List<CategoryModel> data) {
    _subject.add(data);
  }
}
