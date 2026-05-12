import 'package:tylunch/model/cartprod.dart';

extension PROD on List<CartProduct> {
  bool hasProduct(int id) {
    for (final CartProduct p in this) {
      if(id == p.productId) return true;
    }
    return false;
  }
}
