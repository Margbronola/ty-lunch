import 'package:flutter/material.dart';
import 'package:tylunch/global/color.dart';

class SuccessfulRegistrationPage extends StatefulWidget {
  final String email;
  const SuccessfulRegistrationPage({super.key, required this.email});

  @override
  State<SuccessfulRegistrationPage> createState() =>
      _SuccessfulRegistrationPageState();
}

class _SuccessfulRegistrationPageState
    extends State<SuccessfulRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  left: 40,
                  child: Image.asset(
                    'assets/images/image 11.png',
                    width: 200,
                  ),
                )
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              "VOTRE COMPTE\nA ÉTÉ CRÉÉ\nAVEC SUCCÈS !",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: kcPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Un email vous a été envoyé à\nl'adresse",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'CraftRounded',
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
                    text: "\navec les détails de votre compte Ty-Lunch.",
                  ),
                ],
              ),
            ),
            // const Text(
            //   "Un email vous a été envoyé à\nl'adresse john.doe@gmail.com\navec les détails de votre compte Ty-Lunch.",
            //   style: TextStyle(fontSize: 16),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 30),
            SizedBox(
              height: size.height * .2,
              child: Image.asset(
                'assets/images/Frame 2612 (2).png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
