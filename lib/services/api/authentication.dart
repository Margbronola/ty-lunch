// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:tylunch/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tylunch/extension/string.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/datacacher.dart';
import 'package:tylunch/global/network.dart';

class Authentication {
  final DataCacher _cacher = DataCacher.instance;

  Future<String?> login({
    required String token,
  }) async {
    try {
      Map<String, dynamic> body = {
        "firebase_token": token,
        "device_name": "mobile",
      };
      return await http
          .post(
        "${Network.api}/front/auth/login".toUrl,
        headers: {
          "accepts": "application/json",
        },
        body: body,
      )
          .then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          print("USER DATA: $data");
          accesstoken = data['access_token'];
          _cacher.token = accesstoken;
          return data['access_token'];
        }
        Fluttertoast.showToast(msg: "Compte non trouvé");
        print(
            "NAGKA ERROR DIDI LOGIN: ${response.statusCode} ${response.body}");
        return null;
      });
    } catch (e) {
      print("ERROR LOGIN: $e");
      return null;
    }
  }

  Future<String?> register({
    required String email,
    required String name,
    required String lastname,
    required String password,
    required String code,
    required String telephone,
    int? year,
    int? month,
    String? passwordConfirmation,
    // required String firebaseId,
    // required String birthday,
  }) async {
    try {
      print("REGISTRATION PAGE");
      Map<String, dynamic> body = {
        "email": email,
        "name": name,
        "lastname": lastname,
        "password": password,
        "code": code,
        "device_name": "mobile",
        "password_confirmation": passwordConfirmation,
        "telephone": telephone,
      };

      if (year != null) {
        body.addAll({
          "birth_year": year,
        });
      }
      if (month != null) {
        body.addAll({
          "birth_month": month,
        });
      }

      return await http
          .post(
        "${Network.api}/front/client/insert".toUrl,
        headers: {
          "Accept": "application/json",
          'Content-Type': "application/json",
          "Access-Control-Allow-Origin": "*",
          "Cache-Control": "no-cache, private"
        },
        body:
            //  body
            json.encode(body),
      )
          .then((response) {
        print("RESPONSE BODY: ${response.body}");
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          accesstoken = data['access_token'];
          _cacher.token = accesstoken;
          return data['access_token'];
        }
        return null;
      });
    } catch (e) {
      print("ERROR REGISTER : $e");
      return null;
    }
  }

  Future<bool> updateProfile({
    required String id,
    required String email,
    required String name,
    required String lastname,
    required String code,
    required String telephone,
    int? month,
    int? year,
  }) async {
    try {
      Map<String, dynamic> body = {
        "email": email,
        "name": name,
        "lastname": lastname,
        "code": code,
        "telephone": telephone
      };
      print(
          "PASSED DATA: ID: $id, NAME: $name, LASTNAME: $lastname, EMAIL: $email, CODE: $code, TELEPHONE: $telephone");

      if (year != null) {
        body.addAll({
          "birth_year": year.toString(),
        });
      }
      if (month != null) {
        body.addAll({
          "birth_month": month.toString(),
        });
      }

      return await http
          .put("${Network.api}/front/client/update/${id.toString()}".toUrl,
              headers: {
                "Accept": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
                "Authorization": "Bearer $accesstoken"
              },
              body: body
              // json.encode(body),
              )
          .then((response) {
        print("UPDATE PROFILE DATA");
        print("${response.statusCode} - ${response.reasonPhrase}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = json.decode(response.body);
          print("UPDATE PROFILE DATA: $data");
          return true;
        }
        return false;
      });
    } catch (e, s) {
      print("ERROR SA PAG UPDATE $e");
      print("$s");
      return false;
    }
  }

  Future<bool> logout() async {
    print("Access token : $accesstoken");
    try {
      return await http.post(
        "${Network.api}/front/auth/logout".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
      ).then((response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          loggedUser = null;
          accesstoken = null;
          return true;
        }
        return false;
      });
    } catch (e) {
      print("ERROR LOGOUT: $e");
      return false;
    }
  }

  Future<UserModel?> getUserDetails() async {
    try {
      return await http.get(
        "${Network.api}/front/auth/user".toUrl,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $accesstoken"
        },
      ).then((response) {
        var data = json.decode(response.body);
        print("USER DATA: $data");
        if (response.statusCode == 200 || response.statusCode == 201) {
          return UserModel.fromJson(data);
        }
        return null;
      });
    } catch (e, s) {
      print("ERROR GET USER: $e");
      print("ERROR GET USER: $s");
      return null;
    }
  }

  Future<bool> validateEmail({required String email}) async {
    try {
      return await http.post(
        "${Network.api}/front/account_delete/send".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "email": email,
        },
      ).then((response) {
        print(response.body);
        return response.statusCode == 200 || response.statusCode == 201;
      });
    } catch (e) {
      print("ERROR LOGOUT: $e");
      return false;
    }
  }

  Future<bool> validateCode(
      {required String email, required String code}) async {
    try {
      return await http.post(
        "${Network.api}/front/account_delete/validate-code".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "email": email,
          "code": code,
        },
      ).then((response) {
        print(response.body.contains("Veuillez v\u00e9rifier votre e-mail"));
        return response.statusCode == 200 || response.statusCode == 201;
      });
    } catch (e) {
      print("ERROR LOGOUT: $e");
      return false;
    }
  }

  Future<String> checkCompanyCode({required String code}) async {
    try {
      return await http.post(
        "${Network.api}/front/company/check-code".toUrl,
        headers: {
          "Accept": "application/json",
        },
        body: {"company_code": code},
      ).then((response) {
        print("CHECK CODE RETURN ${response.body}");
        if (response.statusCode == 200 || response.statusCode == 200) {
          return "exist";
        }

        Fluttertoast.showToast(msg: "Le code n'existe pas");
        return "not exist";
      });
    } catch (e) {
      print("ERROR LOGOUT: $e");
      return "not exist";
    }
  }

  Future addfcmtoken(
      {required String token,
      required int id,
      required String accesstoken}) async {
    try {
      print("FCM TOKEN PASS: $token");
      return await http
          .post("${Network.api}/front/client/$id/add-fcm".toUrl,
              headers: {
                "Accept": "application/json",
                HttpHeaders.authorizationHeader: "Bearer $accesstoken",
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "no-cache, private",
              },
              body: jsonEncode({"token": token}))
          .then((response) {
        print("ADD FCM TOKEN RESPONSE STATUS: ${response.statusCode}");
        print("ADD FCM TOKEN RETURN: ${response.body}");
        if (response.statusCode == 200) {
          return response.statusCode == 200;
        }
        return null;
      });
    } catch (e) {
      print("ERROR ADDING TOKEN: $e");
      return null;
    }
  }
}
