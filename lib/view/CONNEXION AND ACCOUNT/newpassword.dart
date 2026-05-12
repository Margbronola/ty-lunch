// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/validator.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/changepassword.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/login.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/registration.dart';

class NewPasswordPage extends StatefulWidget {
  String email;
  String otp;
  NewPasswordPage({super.key, required this.email, required this.otp});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  late final TextEditingController password, retypepassword;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();final ChangePassword cp = ChangePassword();
  final CustomWidget cw = CustomWidget();
  bool isloading = false;
  bool isobsecure = false;
  bool isobsecure1 = false;

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    retypepassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    password.dispose();
    retypepassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formkey,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 230,
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/images/Frame 2601 (1).png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          top: 70,
                          left: 20,
                          child: Image.asset(
                            'assets/images/Group 8.png',
                            width: 200,
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget().title(
                            t1: "N",
                            t2: "OUVEAU \nMOT DE PASSE",
                            s1: 40,
                            s2: 35,
                            color: kcPrimary,
                          ),
                          const SizedBox(height: 50),
                          TextFormField(
                            controller: password,
                            obscureText: !isobsecure,
                            validator: (value) {
                              return Validator.emptyfield(value ?? "");
                            },
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Mot de passe",
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsecure = !isobsecure;
                                  });
                                },
                                icon: Icon(
                                  isobsecure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kcPrimary,
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.transparent),
                          TextFormField(
                            controller: retypepassword,
                            obscureText: !isobsecure1,
                            validator: (value) {
                              return Validator.validateConfirmPassword(
                                  value ?? "", password.text);
                            },
                            decoration: InputDecoration(
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              labelText: "Confirmez le mot de passe",
                              labelStyle: const TextStyle(color: Colors.black),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsecure1 = !isobsecure1;
                                  });
                                },
                                icon: Icon(
                                  isobsecure1
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: kcPrimary,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 60,
                              width: size.width * .7,
                              margin:
                                  const EdgeInsets.only(top: 100, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      isloading = true;
                                    });

                                    await cp.newPass(
                                      email: widget.email,
                                      code: widget.otp,
                                      password: password.text,
                                    ).then((value) {
                                      print("SULOD SA VALUE: $value");
                                      if (value == false) {
                                        setState(() {
                                          isloading = false;
                                          Fluttertoast.showToast(msg: "$value");
                                        });
                                        return;
                                      } else {
                                        setState(() {
                                          isloading = false;
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Votre mot de passe a été mis à jour avec succès");
                                        });
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const LoginPage(),
                                            type: PageTransitionType
                                                .rightToLeftWithFade,
                                          ),
                                        );
                                      }
                                    });
                                    // .whenComplete(() => setState(() {
                                    //       isloading = false;
                                    //       Fluttertoast.showToast(
                                    //           msg:
                                    //               "Votre mot de passe a été mis à jour avec succès");
                                    //     }));
                                  }
                                },
                                child: const Text(
                                  "VALIDER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Pas encore inscrit ? ',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: " S'inscrire",
                                    style: const TextStyle(
                                      color: kcPrimary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const RegistrationPage(),
                                            type:
                                                PageTransitionType.leftToRight,
                                          ),
                                        );
                                      }),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isloading ? cw.loader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
