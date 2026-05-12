// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/changepassword.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/passwordchange.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();final ChangePassword cp = ChangePassword();
  final CustomWidget cw = CustomWidget();
  bool isloading = false;

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
                      width: size.width,
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget().title(
                            t1: "M",
                            t2: "OT DE PASSE OUBLIÉ ?",
                            s1: 40,
                            s2: 35,
                            color: kcPrimary,
                          ),
                          const SizedBox(height: 50),
                          cw.textFormField(
                            isfromLogin: true,
                            controller: email,
                            inputType: TextInputType.emailAddress,
                            isEmail: true,
                            label: "Adresse Email",
                          ),
                          Center(
                            child: Container(
                              height: 60,
                              width: size.width * .7,
                              margin:
                                  const EdgeInsets.only(top: 100, bottom: 30),
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

                                    await cp.requestOtp(email: email.text)
                                        .then((value) {
                                      print("SULOD SA VALUE: $value");
                                      if (value == false) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Le compte n'a pas été trouvé");
                                        return;
                                      }
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: PasswordChangePage(
                                            email: email.text,
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
                                  "RÉINITIALISER",
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
                                        Navigator.pushNamed(
                                            context, '/registration_page');
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
              isloading ? CustomWidget().loader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
