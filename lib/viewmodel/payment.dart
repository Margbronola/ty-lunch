import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/payment.dart';

class PaymentViewModel{
  PaymentViewModel._pr();
  static final PaymentViewModel _instance = PaymentViewModel._pr();
  static PaymentViewModel get instance => _instance;
  final BehaviorSubject<List<PaymentModel>> _subject = BehaviorSubject<List<PaymentModel>>();
  Stream<List<PaymentModel>> get stream => _subject.stream;
  List<PaymentModel> get current => _subject.value;

  void populatePayment(List<PaymentModel> payment){
    _subject.add(payment);
  }
}