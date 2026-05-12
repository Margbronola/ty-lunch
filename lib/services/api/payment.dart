// ignore_for_file: avoid_print

import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:tylunch/extension/string.dart";
import "package:tylunch/global/container.dart";
import "package:tylunch/global/network.dart";
import "package:tylunch/model/cartformula.dart";
import "package:tylunch/model/cartprod.dart";
import "package:tylunch/model/cartprod1.dart";
import "package:tylunch/model/edenred.dart";
import "package:tylunch/model/item.dart";
import "package:tylunch/model/new_cart_model.dart";
import "package:tylunch/model/newcart.dart";
import "package:tylunch/services/database.dart";

class PaymentAPI {
  final DatabaseServices db = DatabaseServices.instance;

  Future<String?> payWithBank({required NewCart1Model data}) async {
    try {
      final item = [];

      for (final ItemModel im in data.items) {
        for (final CartFormula cf in im.cartformula) {
          item.add({
            "date": cf.date,
            "formula_id": cf.formulaId,
            "quantity": cf.qty,
            "unit_price": cf.unitPrice,
            "amount": cf.amount,
            "categories": [
              for (int i = 0; i < cf.categories.length; i++)
                {
                  "menu_id": cf.categories[i].menuId,
                  "product_id": cf.categories[i].prodId,
                  "formula_id": cf.categories[i].formulaId,
                  "category_id": cf.categories[i].categoryId,
                }
            ]
          });
        }
        for (final CartProduct1 cp in im.cartproduct) {
          item.add({
            "date": cp.date,
            "product_id": cp.productId,
            "quantity": cp.qty,
            "unit_price": cp.unitPrice,
            "amount": cp.amount,
            "menu_id": cp.menuId,
            "category_id": cp.categoryId
          });
        }
      }

      final payload = {
        "client_id": data.clientId.toString(),
        "subtotal": data.subTotal.toString(),
        "payment_method": data.paymentMethod,
        "use_packaging": data.usePackaging.toString(),
        "items": item,
        "source": "mobile"
      };

      return http
          .post("${Network.api}/front/order/pay-with-bank".toUrl,
              headers: {
                "Accept": "application/json",
                'Content-Type': "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: jsonEncode(payload))
          .then((response) {
        print("SUMULOD DIDI");
        print("PAYMENT STATUSCODE : ${response.statusCode}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("PAY WITH BANK DATA");
          // print("PAYMENT WITH BANK: ${jsonDecode(response.body['errors'][])}");
          debugPrint("PAYMENT BODY : ${response.body}");
          return response.body;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR PAYMENT DISPLAY: $e");
      print("$s");
      return null;
    }
  }

  Future<String?> payWithBankAndPoints({required NewCart1Model data}) async {
    try {
      final item = [];

      for (final ItemModel im in data.items) {
        for (final CartFormula cf in im.cartformula) {
          item.add({
            "date": cf.date,
            "formula_id": cf.formulaId,
            "quantity": cf.qty,
            "unit_price": cf.unitPrice,
            "amount": cf.amount,
            "categories": [
              for (int i = 0; i < cf.categories.length; i++)
                {
                  "menu_id": cf.categories[i].menuId,
                  "product_id": cf.categories[i].prodId,
                  "formula_id": cf.categories[i].formulaId,
                  "category_id": cf.categories[i].categoryId,
                }
            ]
          });
        }
        for (final CartProduct1 cp in im.cartproduct) {
          item.add({
            "date": cp.date,
            "product_id": cp.productId,
            "quantity": cp.qty,
            "unit_price": cp.unitPrice,
            "amount": cp.amount,
            "menu_id": cp.menuId,
            "category_id": cp.categoryId
          });
        }
      }

      final payload = {
        "client_id": data.clientId.toString(),
        "subtotal": data.subTotal.toString(),
        "payment_method": data.paymentMethod,
        "use_packaging": data.usePackaging.toString(),
        "items": item,
        "source": "mobile"
      };

      return http
          .post("${Network.api}/front/order/pay-with-bank-and-points".toUrl,
              headers: {
                "Accept": "application/json",
                'Content-Type': "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: jsonEncode(payload))
          .then((response) {
        print("SUMULOD DIDI");
        print("PAYMENT STATUSCODE : ${response.statusCode}");
        debugPrint("PAYMENT BODY : ${response.body}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("PAY WITH BANK AND POINTS DATA");
          debugPrint("PAYMENT BODY : ${response.body}");
          return response.body;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR PAYMENT DISPLAY: $e");
      print("$s");
      return null;
    }
  }

  Future<String?> payWithPoints(
      {required NewCart1Model data, required List<NewCartModel> ncdata}) async {
    try {
      final item = [];

      for (final ItemModel im in data.items) {
        for (final CartFormula cf in im.cartformula) {
          item.add({
            "date": cf.date,
            "formula_id": cf.formulaId,
            "quantity": cf.qty,
            "unit_price": cf.unitPrice,
            "amount": cf.amount,
            "categories": [
              for (int i = 0; i < cf.categories.length; i++)
                {
                  "menu_id": cf.categories[i].menuId,
                  "product_id": cf.categories[i].prodId,
                  "formula_id": cf.categories[i].formulaId,
                  "category_id": cf.categories[i].categoryId,
                }
            ]
          });
        }
        for (final CartProduct1 cp in im.cartproduct) {
          item.add({
            "date": cp.date,
            "product_id": cp.productId,
            "quantity": cp.qty,
            "unit_price": cp.unitPrice,
            "amount": cp.amount,
            "menu_id": cp.menuId,
            "category_id": cp.categoryId
          });
        }
      }
      print("ITEM : $item");

      final payload = {
        "client_id": data.clientId.toString(),
        "subtotal": data.subTotal.toString(),
        "payment_method": data.paymentMethod,
        "use_packaging": data.usePackaging.toString(),
        "items": item,
        "source": "mobile"
      };
      await http
          .post("${Network.api}/front/order/proceed".toUrl,
              headers: {
                "Accept": "application/json",
                'Content-Type': "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: jsonEncode(payload))
          .then((response) {
        print("SUMULOD DIDI");
        print("PAYMENT STATUSCODE : ${response.statusCode}");
        debugPrint("PAYMENT BODY : ${response.body}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("PAY WITH POINTS DATA");
          for (NewCartModel cart in ncdata) {
            for (CartProduct prod in cart.products) {
              /// delete product
              db.deleteProduct(prodId: prod.productId, cartId: cart.id);
            }
          }
          db.retrieve();
          return response.body;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR PAYMENT DISPLAY: $e");
      print("$s");
      return null;
    }
    return null;
  }

  Future<String?> payWithConecs(
      {required NewCart1Model data, required String selectedConnects}) async {
    try {
      final item = [];

      for (final ItemModel im in data.items) {
        for (final CartFormula cf in im.cartformula) {
          item.add({
            "date": cf.date,
            "formula_id": cf.formulaId,
            "quantity": cf.qty,
            "unit_price": cf.unitPrice,
            "amount": cf.amount,
            "categories": [
              for (int i = 0; i < cf.categories.length; i++)
                {
                  "menu_id": cf.categories[i].menuId,
                  "product_id": cf.categories[i].prodId,
                  "formula_id": cf.categories[i].formulaId,
                  "category_id": cf.categories[i].categoryId,
                }
            ]
          });
        }
        for (final CartProduct1 cp in im.cartproduct) {
          item.add({
            "date": cp.date,
            "product_id": cp.productId,
            "quantity": cp.qty,
            "unit_price": cp.unitPrice,
            "amount": cp.amount,
            "menu_id": cp.menuId,
            "category_id": cp.categoryId
          });
        }
      }

      final payload = {
        "client_id": data.clientId.toString(),
        "subtotal": data.subTotal.toString(),
        "payment_method": data.paymentMethod,
        "use_packaging": data.usePackaging.toString(),
        "items": item,
        "selected_connecs": selectedConnects,
        "source": "mobile"
      };

      return http
          .post("${Network.api}/front/order/pay-connecs".toUrl,
              headers: {
                "Accept": "application/json",
                'Content-Type': "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: jsonEncode(payload))
          .then((response) {
        print("SUMULOD DIDI");
        print("PAYMENT STATUSCODE : ${response.statusCode}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("ADD TO CART BODY : ${response.body}");
          return response.body;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR PAYMENT DISPLAY: $e");
      print("$s");
      return null;
    }
  }

  Future<EdenredModel?> edenredToken({required String? code}) async {
    try {
      print("CODE PASS: $code");
      String clearCode = code!.replaceAll("[", " ").replaceAll("]", " ");
      return await http.post(
        "${Network.api}/front/order/edenred-token".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "code": clearCode,
        },
      ).then((response) {
        print("SUMULOD DIDI");
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          print("EDENRED TOKEN DATA");
          print(response.body);
          return EdenredModel.fromJson(data);
        }
        return null;
      });
    } catch (e) {
      print("ERROR IN EDENRED TOKEN: $e");
    }
  }

  Future<String?> payEdenred(
      {required String? accessToken, required String? refreshToken}) async {
    try {
      print("ACCESS TOKEN: $accessToken");
      print("REFRESHTOKEN: $refreshToken");
      return await http.post(
        "${Network.api}/front/order/pay-edenred".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "access_token": accessToken,
          "refresh_token": refreshToken,
        },
      ).then((response) {
        print("SUMULOD DIDI PAY WITH EDENRED");
        print("PAYMENT STATUSCODE : ${response.statusCode}");
        print("PAYMENT STATUSCODE : ${response.reasonPhrase}");
        debugPrint("BODY : ${response.body}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("PAY EDENRED DATA");
          return response.body;
        }
        return response.body;
      });
    } catch (e) {
      print("ERROR IN PAY EDENRED: $e");
    }
  }

  Future<String?> addCard(
      {required String card,
      required String cvv,
      required String expiry}) async {
    try {
      return await http.post(
        "${Network.api}/front/subscriber/add-card".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "card": card,
          "cvv": cvv,
          "expiry": expiry,
        },
      ).then((response) {
        print("SUMULOD DIDI");
        print("ADD CARD STATUSCODE : ${response.statusCode}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          print("ADD CARD DATA DATA");
          debugPrint("ADD CARD BODY : ${response.body}");
          return response.body;
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR ADD CARD: $e");
      print("$s");
      return null;
    }
  }

  Future<void> getCard() async {
    try {
      await http.get(
          "${Network.api}/front/subscriber/client/card-subscription".toUrl,
          headers: {
            "Accepts": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $accesstoken"
          }).then((response) {
        print("RESPONSE STATUS: ${response.statusCode}");
        print("RESPONSE BODY: ${response.body}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("CARD BODY : ${response.body}");
        }
        return;
      });
    } catch (e, s) {
      print("ERROR CARD DISPLAY: $e");
      print("$s");
      return;
    }
  }
}
