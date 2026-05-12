// ignore_for_file: avoid_print

import 'dart:io';
import '../../global/network.dart';
import '../../global/container.dart';
import "package:http/http.dart" as http;
import 'package:tylunch/extension/string.dart';

class ChangePassword {
  Future<bool> requestOtp({required String email}) async {
    try {
      return await http.get(
        "${Network.api}/front/send-email-validation?email=$email".toUrl,
        headers: {
          "Accept": "application/json",
          'Content-Type': "application/json",
          "Access-Control-Allow-Origin": "*",
          "Cache-Control": "no-cache, private",
          "Authorization": "Bearer $accesstoken"
        },
      ).then((response) {
        if (response.body.contains("Le compte n'a pas")) {
          return false;
        } else if (response.body.contains("Veuillez")) {
          print("RESPONSE BODY: ${response.body}");
          return true;
        }
        return false;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateCode(
      {required String email, required String code}) async {
    try {
      return await http.get(
        "${Network.api}/front/validate-code?code=$code&email=$email".toUrl,
        headers: {
          "Accept": "application/json",
          'Content-Type': "application/json",
          "Access-Control-Allow-Origin": "*",
          "Cache-Control": "no-cache, private",
          "Authorization": "Bearer $accesstoken"
        },
      ).then((response) {
        if (response.body.contains("Code de")) {
          return false;
        } else if (response.body.contains("de la validation du code")) {
          return true;
        }
        return false;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> newPass(
      {required String email,
      required String code,
      required String password}) async {
    try {
      print("code=$code&email=$email}");
      return await http.put(
        "${Network.api}/front/update-password?code=$code&email=$email".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "password": password,
        },
      ).then((response) {
        print(response.body);
        return response.statusCode == 200 || response.statusCode == 201;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePass(
      {required String password, required String retypepassword}) async {
    try {
      return await http.post(
        "${Network.api}/front/client/changePassword".toUrl,
        headers: {
          "Accept": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accesstoken"
        },
        body: {
          "password": password,
          "password_confirmation": retypepassword,
        },
      ).then((response) {
        print(response.body);
        return response.statusCode == 200 || response.statusCode == 201;
      });
    } catch (e) {
      return false;
    }
  }
}
