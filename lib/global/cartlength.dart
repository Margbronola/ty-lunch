// ignore_for_file: camel_case_types

import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/model/new_cart_model.dart';

class getCartLength {
  int getLength(List<NewCartModel> model) {
    if (model.isNotEmpty) {
      int l = 0;
      int cartProdQty = 0;
      for (final NewCartModel cart in model) {
        print("GET LENGHT: $cart");
        l = l + cart.products.length;
        for (final CartProduct cartProd in cart.products) {
          print("CART PRODUCT: $cartProd");
          cartProdQty = cartProdQty + cartProd.quantity;
          print("CART PRODUCT: $cartProdQty");
        }
      }
      return cartProdQty;
    }
    return 0;
  }
}
