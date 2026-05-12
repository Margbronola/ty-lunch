import 'package:flutter/material.dart';
import 'package:tylunch/services/api/authentication.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final Authentication auth = Authentication();
  bool isloading = false;
  String otp = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
