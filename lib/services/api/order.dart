// ignore_for_file: avoid_print

import 'package:intl/intl.dart';
import 'package:tylunch/extension/string.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/network.dart';
import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/model/product_regroup.dart';
import 'package:tylunch/services/database.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;

import '../../model/remap_formula.dart';
import '../../model/remap_individual.dart';
import '../../viewmodel/product_regroup.dart';

class OrderAPI {
  final OrderHistoryViewModel _viewModel = OrderHistoryViewModel.instance;
  final ProductRegroupViewModel _productRegroupViewModel =
      ProductRegroupViewModel.instance;
  final DatabaseServices db = DatabaseServices.instance;
  double indisubtotal = 0.0;
  double formusubtotal = 0.0;

  Future<void> getOrderHistory() async {
    try {
      await http.get("${Network.api}/front/order/list".toUrl, headers: {
        "Accepts": "Application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          List data = json.decode(response.body);
          _viewModel.populate(
              data.map((e) => OrderHistoryModel.fromJson(e)).toList());
        }
      });
      return;
    } catch (e) {
      return;
    }
  }

  Future<bool?> addtoCart({
    required String date,
    required int day,
    required int menuId,
    required int prodId,
    required int catId,
    required int orderQty,
  }) async {
    try {
      print("PARAMS: $day, $date, $menuId, $prodId, $catId, $orderQty");
      return await http
          .post(
        "${Network.api}/front/menus/check/product-order".toUrl,
        headers: {
          "Accept": "application/json",
          'Content-Type': "application/json",
          "Access-Control-Allow-Origin": "*",
          "Cache-Control": "no-cache, private",
          "Authorization": "Bearer $accesstoken"
        },
        body: json.encode({
          "day": day.toString(),
          "date": date,
          "menu_id": menuId,
          "product_id": prodId,
          "category_id": catId,
          "order_quantity": orderQty,
        }),
      )
          .then((response) {
        print("SUMULOD DIDI");
        print("ADD CARD STATUSCODE : ${response.statusCode}");
        print("ERROR: ${response.reasonPhrase}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("RESPONSE BODY: ${response.body}");
          return response.body.contains("true");
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR ADD TO CART: $e");
      print("$s");
      return null;
    }
  }

  Future<List<ProductRegroupModel>?> addToFormula(
      {required List<NewCartModel> cartdata}) async {
    try {
      List bodies = [];
      for (int i = 0; i < cartdata.length; i++) {
        for (int j = 0; j < cartdata[i].products.length; j++) {
          bodies.add({
            "date":
                DateFormat("yyyy-MM-dd").format(cartdata[i].date).toString(),
            "product_id": cartdata[i].products[j].productId.toString(),
            "order_quantity": cartdata[i].products[j].quantity.toString(),
            "menu_id": cartdata[i].products[j].menuId.toString(),
            "category_id": cartdata[i].products[j].categoryId.toString(),
            "day": cartdata[i].products[j].day.toString()
          });
        }
      }
      final Map<String, dynamic> body = {
        "orders": bodies,
      };
      return http
          .post("${Network.api}/front/menus/product-regroup".toUrl,
              headers: {
                "Accept": "application/json",
                'Content-Type': "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: json.encode(body))
          .then((response) async {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          var formula = data["regroup"];
          List<ProductRegroupModel> remapFormula = List.from(formula)
              .map((e) => ProductRegroupModel.fromJson(e))
              .toList();
          _productRegroupViewModel.populate(remapFormula);
          for (final NewCartModel cart in cartdata) {
            for (final ProductRegroupModel prm in remapFormula) {
              if (DateFormat("yyyy-MM-dd").format(cart.date) == prm.date) {
                if (prm.remapIndividual!.isNotEmpty) {
                  for (final RemapIndividualModel rim in prm.remapIndividual!) {
                    print("INDIVIDUAL AMOUNT : ${rim.total}");
                    indisubtotal = indisubtotal + rim.total;
                    print("INDIVIDUAL TOTAL : $indisubtotal");
                  }
                }
                if (prm.remapFormula!.isNotEmpty) {
                  for (final RemapFormulaModel rfm in prm.remapFormula!) {
                    print("FORMULA AMOUNT : ${rfm.amount}");
                    formusubtotal = formusubtotal + rfm.amount;
                    print("FORMULA TOTAL : $formusubtotal");
                  }
                }
                print("TOTAL : ${indisubtotal + formusubtotal}");
                db.updateSubTotal(
                    cartId: cart.id, subtotal: formusubtotal + indisubtotal);
                indisubtotal = 0.0;
                formusubtotal = 0.0;
              }
            }
          }
          print("FORMULA DATA RETURN : $remapFormula");
          return remapFormula;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR FORMULE : $e $s");
      return null;
    }
  }

  Future<void> addOrder({
    required List<NewCartModel> data,
  }) async {
    try {
      final body = {};
      for (int i = 0; i < data.length; i++) {
        final DateTime dataDate = (data[i].date);
        final DateTime date = DateTime.now();
        final bool isAfter = date.isAfter(dataDate);
        final DateTime payloadDate;
        if (isAfter) {
          payloadDate = date;
        } else {
          payloadDate = dataDate;
        }

        body.addAll({"orders[$i][client_id]": data[i].clientId.toString()});
        body.addAll({"orders[$i][date]": payloadDate.toString()});
        body.addAll({"orders[$i][subtotal]": data[i].subTotal.toString()});
        for (int j = 0; j < data[i].products.length; j++) {
          body.addAll({
            "orders[$i][items][$j][${data[i].products[j].isFormula ? "formula_id" : "product_id"}]":
                data[i].products[j].productId.toString()
          });
          body.addAll({
            "orders[$i][items][$j][quantity]":
                data[i].products[j].quantity.toString()
          });
          body.addAll({
            "orders[$i][items][$j][unit_price]":
                data[i].products[j].price.toString()
          });
          body.addAll({
            "orders[$i][items][$j][amount]":
                data[i].products[j].total.toString()
          });
        }
        // body.addAll({"orders[$i][payment_method]": data[i].paymentMethod});
      }
      await http
          .post("${Network.api}/front/order/insert".toUrl,
              headers: {
                "Accept": "Application/Json",
                HttpHeaders.authorizationHeader: "Bearer $accesstoken"
              },
              body: body)
          .then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var dat = json.decode(response.body);
          print("DATA : $dat");
          for (NewCartModel cart in data) {
            for (CartProduct prod in cart.products) {
              /// delete product
              await db.deleteProduct(prodId: prod.productId, cartId: cart.id);
            }
          }
          List<OrderHistoryModel> order =
              List.from(dat).map((e) => OrderHistoryModel.fromJson(e)).toList();
          await db.retrieve();
          print("ADDED ORDER $order");
          _viewModel.populate(order);
        }
        return;
      });
    } catch (e, s) {
      print("ERROR CHECKOUT : $e $s");
      return;
    }
  }
}
