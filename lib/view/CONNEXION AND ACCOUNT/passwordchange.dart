// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/verificationcode.dart';

class PasswordChangePage extends StatefulWidget {
  String email;
  PasswordChangePage({super.key, required this.email});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget().title(
                        t1: "E",
                        t2: "MAIL ENVOYÉ !",
                        s1: 40,
                        s2: 35,
                        color: kcPrimary),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Un email vous a été envoyé à l'adresse ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Ebrima',
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                color: kcPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(
                              text: " pour changer votre mot de passe !",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/images/Frame 2612 (2).png',
                      fit: BoxFit.fitWidth,
                    ),
                    Container(
                      height: 60,
                      width: size.width * .7,
                      margin: const EdgeInsets.only(top: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: VerificationCodePage(
                                email: widget.email,
                              ),
                              type: PageTransitionType.rightToLeftWithFade,
                            ),
                          );
                        },
                        child: Text(
                          "Saisir le code".toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
