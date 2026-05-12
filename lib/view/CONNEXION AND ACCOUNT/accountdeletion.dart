import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/authentication.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/verifycode.dart';

class AccountDeletionPage extends StatefulWidget {
  const AccountDeletionPage({super.key});

  @override
  State<AccountDeletionPage> createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<AccountDeletionPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late final TextEditingController email;
  final Authentication auth = Authentication();
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
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
                      children: [
                        CustomWidget().title(
                          t1: "S",
                          t2: "upprime mon compte".toUpperCase(),
                          s1: 40,
                          s2: 35,
                          color: kcPrimary,
                        ),
                        const SizedBox(height: 50),
                        CustomWidget().textFormField(
                          isfromLogin: true,
                          controller: email,
                          inputType: TextInputType.emailAddress,
                          isEmail: true,
                          label: "Adresse Email",
                        ),
                        Center(
                          child: Container(
                            height: 55,
                            width: size.width * .7,
                            margin: const EdgeInsets.only(top: 70),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kcPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await auth
                                      .validateEmail(email: email.text)
                                      .then((value) {
                                    print("VALUEEE: $value");
                                    if (value == true) {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          child: const VerifyCodePage(),
                                          type: PageTransitionType.leftToRight,
                                        ),
                                      );
                                      // setState(() {
                                      //   isloading = false;
                                      //   Fluttertoast.showToast(
                                      //       msg: "Mot de passe modifié");
                                      // });
                                    }
                                  });
                                  // Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                "CONFIRMER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                              height: 55,
                              width: size.width * .7,
                              margin: const EdgeInsets.only(bottom: 50),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Retour",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: kcPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
