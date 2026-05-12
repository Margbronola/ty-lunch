// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:tylunch/extension/string.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/network.dart';
import 'package:tylunch/model/formula.dart';
import 'package:tylunch/viewmodel/formula.dart';
import "package:http/http.dart" as http;

class FormulaApi {
  static final FormulaViewModel _viewModel = FormulaViewModel.instance;

  Future<List<FormulaModel>?> getFormula() async {
    try {
      await http.get("${Network.api}/front/formula/list".toUrl, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $accesstoken"
      }).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          List<FormulaModel> formula1 =
              List.from(data).map((e) => FormulaModel.fromJson(e)).toList();
          _viewModel.populate(formula1);
          formula = formula1;
          return formula;
        }
        return null;
      });
    } catch (e) {
      print("ERROR IN FORMULA: $e");
      return null;
    }
    return null;
  }
}
