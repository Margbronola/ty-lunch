import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/formula.dart';

class FormulaViewModel{
  FormulaViewModel._pr();
  static final FormulaViewModel _instance = FormulaViewModel._pr();
  static FormulaViewModel get instance => _instance;
  final BehaviorSubject<List<FormulaModel>> _subject = BehaviorSubject<List<FormulaModel>>();
  Stream<List<FormulaModel>> get stream => _subject.stream;
  List<FormulaModel> get current => _subject.value;
  
  void populate(List<FormulaModel> data){
    _subject.add(data);
   }
}