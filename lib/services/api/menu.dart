// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:tylunch/extension/string.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/network.dart';
import 'package:tylunch/model/category.dart';
import 'package:tylunch/model/nextweekmenu.dart';
import 'package:tylunch/model/product.dart';
import 'package:tylunch/viewmodel/product.dart';
import '../../model/weeklymenu.dart';
import '../../viewmodel/category.dart';
import '../../viewmodel/weekly_menu.dart';

class MenuApi {
  static final WeeklyMenuViewModel _weekdaysVM = WeeklyMenuViewModel.instance;
  static final CategoryViewModel _categoryVM = CategoryViewModel.instance;
  static final ProductViewModel _productVM = ProductViewModel.instance;

  Future<void> getMenu() async {
    try {
      await http.get("${Network.api}/front/menus/weekly".toUrl, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          var menu = data["results"];
          print("MENU DATA: $data");
          print("MENU DATA: $menu");
          WeeklyMenuModel ffMenu = WeeklyMenuModel.fromJson(data);
          _weekdaysVM.populate(ffMenu);
        }
        return;
      });
    } catch (e, s) {
      print("ERROR THIS WEEK MENU DISPLAY: $e");
      print("$s");
      return;
    }
  }

  Future<NextWeekMenuModel?> getNextWeekMenu() async {
    try {
      return await http.get(
          "${Network.api}/front/menus/show/next-week-menus".toUrl,
          headers: {
            "Accepts": "application/json",
            HttpHeaders.authorizationHeader: "Bearer $accesstoken"
          }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          print("NEXT WEEK MENU: $data");
          return NextWeekMenuModel.fromJson(data);
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR NEXT WEEK MENU DISPLAY: $e");
      print("$s");
      return null;
    }
  }

  Future<void> getMenuByDate({required String date}) async {
    try {
      await http
          .get("${Network.api}/front/menus/weekly?date=$date".toUrl, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          print("NEXT WEEK MENU: $data");
          WeeklyMenuModel ffMenu = WeeklyMenuModel.fromJson(data);
          _weekdaysVM.populate(ffMenu);
        }
        return;
      });
    } catch (e, s) {
      print("ERROR NEXT WEEK MENU DATA DISPLAY: $e");
      print("$s");
      return;
    }
  }

  Future<void> getCategory() async {
    try {
      await http.get("${Network.api}/front/category/list".toUrl, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          List<CategoryModel> category =
              List.from(data).map((e) => CategoryModel.fromJson(e)).toList();
          _categoryVM.populate(category);
        }
        return;
      });
    } catch (e, s) {
      print("ERROR CATEGORY DISPLAY: $e");
      print("$s");
      return;
    }
  }

  Future<void> getProduct() async {
    try {
      await http.get("${Network.api}/front/product/list".toUrl, headers: {
        "Accepts": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          List<ProductModel> product =
              List.from(data).map((e) => ProductModel.fromJson(e)).toList();
          _productVM.populate(product);
        }
        return;
      });
    } catch (e, s) {
      print("ERROR PRODUCT DISPLAY: $e");
      print("$s");
      return;
    }
  }
}
