// ignore_for_file: avoid_print, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> create({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential creds = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (creds.user == null) return null;
      return await creds.user!.getIdToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "Aucun utilisateur trouvé");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Mot de passe incorrect");
      } else if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(msg: "Email déjà utilisé");
      } else if (e.code == "invalid-email") {
        Fluttertoast.showToast(
          msg:
              "Problème avec le format de l’email. Veuillez vérifier qu’il ne contient pas d’espace.",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (e.code == "weak-password") {
        Fluttertoast.showToast(msg: "Mot de passe faible");
      }
      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "Pas de connexion Internet");
      return null;
    } on HttpException {
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de l'exécution de cette opération",
      );
      return null;
    } on FormatException {
      Fluttertoast.showToast(msg: "Erreur de format");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Pas de connexion Internet : timeout");
      return null;
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    print("EMAIL & PASSWORD: $email - $password");
    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      print("EMAIL & PASSWORD: $email - $password");
      final UserCredential authResult = await auth.signInWithCredential(
        credential,
      );
      // email: email, password: password);
      print("AUTH RESULT: ${authResult.user}");
      if (authResult.user == null) return null;
      return await authResult.user?.getIdToken();
    } on FirebaseAuthException catch (e, s) {
      print("ERROR ON SIGNIN IN FIREBASE: $e $s");
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "Aucun utilisateur trouvé");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Mot de passe incorrect");
      } else if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(msg: "Email déjà utilisé");
      } else if (e.code == "") {}
      return null;
    } on SocketException {
      Fluttertoast.showToast(msg: "Pas de connexion Internet");
      return null;
    } on HttpException {
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de l'exécution de cette opération",
      );
      return null;
    } on FormatException catch (e) {
      Fluttertoast.showToast(msg: "Erreur de format: $e");
      return null;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Pas de connexion Internet : timeout");
      return null;
    }
  }
}
