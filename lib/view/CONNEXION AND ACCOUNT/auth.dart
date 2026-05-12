import 'package:flutter/material.dart';

import '../../global/color.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
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
                    fit: BoxFit.fitWidth,
                  ),
                )
              ],
            ),
            Container(
              // width: double.infinity,
              height: 400,
              // alignment: Alignment.center,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: size.width * .7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login_page');
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
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 60,
                    width: size.width * .7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration_page');
                      },
                      child: const Text(
                        "CRÉER MON COMPTE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
