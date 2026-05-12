// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/changepassword.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/newpassword.dart';

class VerificationCodePage extends StatefulWidget {
  String email;
  VerificationCodePage({super.key, required this.email});

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();final ChangePassword cp = ChangePassword();
  final CustomWidget cw = CustomWidget();
  bool isloading = false;
  bool _onEditing = true;
  String otp = "";

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
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidget().title(
                            t1: "C",
                            t2: "ODE DE VÉRIFICATION",
                            s1: 40,
                            s2: 35,
                            color: kcPrimary,
                          ),
                          const SizedBox(height: 70),
                          VerificationCode(
                            underlineUnfocusedColor: Colors.grey.shade500,
                            underlineWidth: 3,
                            autofocus: true,
                            textStyle: const TextStyle(
                              fontSize: 30,
                            ),
                            underlineColor: kcPrimary,
                            keyboardType: TextInputType.number,
                            length: 6,
                            cursorColor: Colors.black,
                            onCompleted: (String value) {
                              setState(() {
                                print(value);
                                otp = value;
                              });
                            },
                            onEditing: (bool value) {
                              setState(() {
                                _onEditing = value;
                              });
                              if (!_onEditing) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                          const SizedBox(height: 40),
                          Container(
                            height: 60,
                            width: size.width * .7,
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pink,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              onPressed: () async {
                                if (otp.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Entrez le code de vérification");
                                  return;
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await cp.validateCode(
                                          email: widget.email, code: otp)
                                      .then((value) {
                                    print("SULOD SA VALUE: $value");
                                    if (value == false) {
                                      Fluttertoast.showToast(
                                          msg: "Code de validation non valide");
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: NewPasswordPage(
                                          email: widget.email,
                                          otp: otp,
                                        ),
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
                                      ),
                                    );
                                  }).whenComplete(() =>
                                          setState(() => isloading = false));
                                }
                              },
                              child: const Text(
                                "SUIVANT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
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
