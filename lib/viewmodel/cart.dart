import 'package:rxdart/subjects.dart';
import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/services/database.dart';

class CartViewModel {
  CartViewModel._pr();
  static final CartViewModel _instance = CartViewModel._pr();
  static CartViewModel get instance {
    return _instance;
  }

  final BehaviorSubject<List<NewCartModel>> _subject =
      BehaviorSubject<List<NewCartModel>>();
  Stream<List<NewCartModel>> get stream => _subject.stream;
  List<NewCartModel> get current => _subject.value;
  final DatabaseServices db = DatabaseServices.instance;

  void populate(List<NewCartModel> data) {
    _subject.add(data);
  }

  void dispose() {
    populate([]);
  }

  void remove(List<NewCartModel> carts) async {
    for (NewCartModel cart in carts) {
      for (CartProduct prod in cart.products) {
        await db.deleteProduct(prodId: prod.productId, cartId: cart.id);
      }
    }
  }
}
