// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/view/landing.dart';

class PaymentSuccessfulPage extends StatefulWidget {
  const PaymentSuccessfulPage({super.key});

  @override
  State<PaymentSuccessfulPage> createState() => _PaymentSuccessfulPageState();
}

class _PaymentSuccessfulPageState extends State<PaymentSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/Asset1.svg",
            color: kcPrimary,
            width: 200,
          ),
          const SizedBox(height: 50),
          Center(
            child: Text(
              "votre commande a bien\nété prise en compte !".toUpperCase(),
              style: const TextStyle(
                  color: kcPrimary, fontWeight: FontWeight.bold, fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 90),
          SizedBox(
            height: 55,
            width: size.width * .7,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LandingPage(ind: 0)),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                "j'ai terminé".toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/Asset2.png",
                width: 170,
              ),
              // SvgPicture.asset(
              //   "assets/icons/Asset2.svg",
              // ),
              const SizedBox(width: 15),
              const Text(
                "\n\n\nÀ très bientôt\nL'équipe Ty-Lunch",
                style: const TextStyle(
                    color: kcPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}
