// ignore_for_file: avoid_print

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/services/api/order.dart';
import 'package:tylunch/viewmodel/cart.dart';

class DatabaseServices {
  DatabaseServices._pr();
  static final DatabaseServices _instance = DatabaseServices._pr();
  static DatabaseServices get instance => _instance;

  static final CartViewModel _cartViewModel = CartViewModel.instance;

  Future<Database> _initDB() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, "tylunch73.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDB();

  Future _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, subtotal DOUBLE, date TEXT, user_id INT NOT NULL)');
    await db.execute(
        'CREATE TABLE product(id INTEGER PRIMARY KEY AUTOINCREMENT, prodId INT, name TEXT NOT NULL, meals TEXT, price DOUBLE NOT NULL, isformula INT DEFAULT 0,  total DOUBLE NOT NULL ,quantity INT NOT NULL, menuId INT, day INT NOT NULL, categoryId INT NOT NULL,  image TEXT, cart_id INT NOT NULL, FOREIGN KEY (cart_id) REFERENCES cart (id))');
  }

  /// RETRIEVE DATA IN DATABASE
  Future<List<NewCartModel>?> retrieve() async {
    try {
      final Database db = await instance.database;
      final List data = await db
          .rawQuery("SELECT * FROM cart WHERE user_id = ${loggedUser!.id}");
      final List<NewCartModel> res = [];
      for (Map<String, dynamic> datum in data) {
        List products = await db
            .rawQuery("SELECT * FROM product WHERE cart_id = ${datum['id']}");
        final NewCartModel cartModel = NewCartModel(
          id: datum['id'],
          subTotal: datum['subtotal'],
          date: DateTime.parse(datum['date']),
          clientId: loggedUser!.id,
          products: products
              .map((e) => CartProduct.fromJson(
                  e, e["isformula"] == null ? false : e['isformula'] == 1))
              .toList(),
        );
        print(
            "LORIENNTTTT ON CART: ${DateFormat("yyyy-MM-dd").format(DateTime.parse(cartModel.date.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >= 0}");
        if (cartModel.subTotal == 0.0) {
          deleteCartData(cartId: datum['id']);
        } else if (loggedUser!.company.deliveryType == 1
            ? DateFormat("yyyy-MM-dd").format(DateTime.now()).compareTo(
                        DateFormat("yyyy-MM-dd").format(
                            DateTime.parse(cartModel.date.toString()))) ==
                    0
                ? DateFormat("yyyy-MM-dd").format(DateTime.now()).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.parse(cartModel.date.toString()))) == 0 &&
                    DateFormat("HH:mm").format(DateTime.now()).compareTo("10:30") <
                        0
                : DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(cartModel.date.toString()))
                        .compareTo(DateFormat("yyyy-MM-dd").format(
                            DateTime.now().add(const Duration(days: 1)))) >=
                    0
            : DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(cartModel.date.toString()))
                        .compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >=
                    0
                ? DateFormat("HH:mm").format(DateTime.now()).compareTo("18:00") < 0
                    ? DateFormat("HH:mm").format(DateTime.now()).compareTo("18:00") < 0 && DateFormat("yyyy-MM-dd").format(DateTime.parse(cartModel.date.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >= 0
                    : DateFormat("yyyy-MM-dd").format(DateTime.parse(cartModel.date.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 2)))) >= 0
                : DateFormat("yyyy-MM-dd").format(DateTime.parse(cartModel.date.toString())).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 2)))) >= 0) {
          res.add(cartModel);
          cartLength = cartModel.products.length;
        } else {
          deleteCartData(cartId: datum['id']);
        }
        print("CART MODEL FROM DATABASE: $cartModel");
      }
      print("RESSSSS FROM DATABASE: $res");
      res.sort((a, b) {
        return a.date.compareTo(b.date);
      });
      _cartViewModel.populate(res);
      await OrderAPI().addToFormula(cartdata: res);
      double amount = 0.0;
      for (final NewCartModel cart in res) {
        amount += cart.subTotal;
      }
      total = amount;

      print("DATA FROM DATABASE: $res");
      return res;
    } catch (e, s) {
      print("ERROR DATABASE: $e, $s");
      return null;
    }
  }

  // // UPDATE DATE IN CART
  // Future<void> updateDate({required int cartId, required String date}) async {
  //   final Database db = await instance.database;
  //   await db.update('cart', {'date': date}, where: 'id = $cartId');
  // }

  /// UPDATE ITEM IN DATABASE
  Future<void> updateItem(
      {required int cartId, required CartProduct product}) async {
    final Database db = await instance.database;
    print("UPDATE");
    final CartProduct? prevItem = await getProduct(id: product.productId);
    if (prevItem == null) return;
    await db.update(
        "product",
        {
          "prodId": product.productId,
          "quantity": product.quantity.toInt() + prevItem.quantity,
          "total":
              (product.quantity.toInt() + prevItem.quantity) * product.price
        },
        where: "prodId = ${product.productId} AND cart_id = $cartId");
    double total = await getCurrentTotal(cartId);
    await updateSubTotal(cartId: cartId, subtotal: total);
    await retrieve();
  }

  /// UPDATE ITEM QTY IN DATABASE
  Future<void> updateQty(
      {required int cartId,
      required CartProduct product,
      required int qty}) async {
    final Database db = await instance.database;
    print("UPDATE");
    final CartProduct? prevItem = await getProduct(id: product.productId);
    if (prevItem == null) return;
    await db.update(
        "product",
        {
          "prodId": product.productId,
          "quantity": qty,
          "total": qty * product.price
        },
        where: "prodId = ${product.productId} AND cart_id = $cartId");
    double total = await getCurrentTotal(cartId);
    await updateSubTotal(cartId: cartId, subtotal: total);
    await retrieve();
  }

  /// DELETE DATA IN DATABASE
  Future<void> deleteCartData({required int cartId}) async {
    final Database db = await instance.database;
    await db.delete("cart", where: "id = $cartId");
    await updateSubTotal(
        cartId: cartId, subtotal: await getCurrentTotal(cartId));
    // await retrieve();
  }

  Future<void> deleteProduct({
    required int prodId,
    required int cartId,
  }) async {
    final Database db = await instance.database;
    await db.delete('product', where: 'prodId = $prodId AND cart_id = $cartId');
    await updateSubTotal(
        cartId: cartId, subtotal: await getCurrentTotal(cartId));
    await retrieve();
  }

  /// GET TOTAL
  Future<double> getCurrentTotal(int cartId) async {
    final List<CartProduct> toAdd = await getCartProducts(cartId: cartId);
    if (toAdd.isEmpty) return 0;
    double nTotal = 0.0;
    for (final CartProduct element in toAdd) {
      nTotal = nTotal + element.total;
    }
    await updateSubTotal(cartId: cartId, subtotal: nTotal);
    return nTotal;
  }

  Future<void> updateSubTotal(
      {required int cartId, required double subtotal}) async {
    print("gi update an amount");
    print("TOTAL : $subtotal");
    final Database db = await instance.database;
    await db.update('cart', {'subtotal': subtotal}, where: 'id = $cartId');
  }

  /// GET PRODUCTS
  Future<CartProduct?> getProduct({required int id}) async {
    final Database db = await instance.database;
    final List prod = await db.query("product", where: "prodId = $id");
    if (prod.isEmpty) return null;
    return CartProduct.fromJson(prod.first);
  }

  Future<List<CartProduct>> getCartProducts({required int cartId}) async {
    try {
      print(cartId);
      final Database db = await instance.database;
      var data = await db.rawQuery(
        "SELECT * FROM product WHERE cart_id = $cartId",
      );
      if (data.isNotEmpty) {
        final List<CartProduct> ff = [];
        for (var item in data) {
          ff.add(CartProduct.fromJson(item));
        }
        return ff;
      }
      return [];
    } catch (e) {
      print("ERROR GET CART : $e");
      return [];
    }
  }

  ///ADDING ITEM IN DATABASE
  Future<int> addItem(NewCartModel model) async {
    try {
      print("DATA INSERT: $model");
      int result = 0;
      final Database db = await instance.database;
      await db.insert('cart', {
        "subtotal": model.subTotal.toDouble(),
        "user_id": loggedUser!.id,
        "date": model.date.toString(),
      }).then((int cartId) async {
        for (CartProduct product in model.products) {
          await addSingleItem(cartId: cartId, product: product);
        }
      });
      return result;
    } catch (e, s) {
      print("ERROR IN ADDING IN DATABASE: $e");
      print("ERROR IN ADDING IN DATABASE: $s");
      return 0;
    }
  }

  Future<void> addSingleItem(
      {required int cartId, required CartProduct product}) async {
    final Database db = await instance.database;
    final Map<String, dynamic> body = {
      "prodId": product.productId,
      "name": product.name,
      "price": product.price.toDouble(),
      "total": product.quantity.toInt() * product.price.toDouble(),
      "quantity": product.quantity.toInt(),
      "image": product.image,
      "day": product.day,
      "menuId": product.menuId,
      "categoryId": product.categoryId,
      "cart_id": cartId,
      "isformula": product.isFormula ? 1 : 0,
    };
    if (product.meals != null) {
      body.addAll({'meals': product.meals});
    }
    await db.insert("product", body);
    await updateSubTotal(
      cartId: cartId,
      subtotal: await getCurrentTotal(cartId),
    );
  }
}
