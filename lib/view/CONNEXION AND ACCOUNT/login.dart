// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/validator.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/authentication.dart';
import 'package:tylunch/services/firebase.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/forgotpass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController email, password;

  final CustomWidget cw = CustomWidget();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static final CustomAuth _auth = CustomAuth();
  static final Authentication _authApi = Authentication();
  bool isobsecure = false;
  bool isloading = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
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
                          cw.title(
                            t1: "C",
                            t2: "ONNEXION",
                            s1: 40,
                            s2: 35,
                            color: kcPrimary,
                          ),
                          const Text(
                            "J’accède à mon compte.",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 30),
                          cw.textFormField(
                            isfromLogin: true,
                            controller: email,
                            inputType: TextInputType.emailAddress,
                            isEmail: true,
                            label: "Adresse Email",
                          ),
                          const Divider(color: Colors.transparent),
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
                          const SizedBox(height: 50),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const ForgotPasswordPage(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                  ),
                                );
                              },
                              child: const Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              height: 60,
                              width: size.width * .7,
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
                                    await _auth
                                        .signIn(
                                            email: email.text,
                                            password: password.text)
                                        .then((value) async {
                                      print("FIREBASE LOGIN $value");
                                      if (value == null) return null;
                                      await _authApi
                                          .login(token: value)
                                          .then((value) async {
                                        if (value != null) {
                                          Navigator.pushNamed(
                                              context, '/landing_page');
                                        }
                                      });
                                    }).whenComplete(
                                      () => setState(() => isloading = false),
                                    );
                                  }
                                },
                                child: const Text(
                                  "SE CONNECTER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Pas encore inscrit ? ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
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
                    )
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
