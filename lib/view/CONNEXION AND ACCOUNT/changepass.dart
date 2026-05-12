import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../global/color.dart';
import '../../global/validator.dart';
import '../../global/widget.dart';
import '../../services/api/changepassword.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final ChangePassword cp = ChangePassword();
  final CustomWidget cw = CustomWidget();
  late final TextEditingController oldpassword, newpassword, retypenewpass;
  bool isloading = false;
  bool isobsecure1 = false;
  bool isobsecure2 = false;
  bool isobsecure3 = false;

  @override
  void initState() {
    super.initState();
    oldpassword = TextEditingController();
    newpassword = TextEditingController();
    retypenewpass = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    oldpassword.dispose();
    newpassword.dispose();
    retypenewpass.dispose();
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
                              t1: "N",
                              t2: "OUVEAU \nMOT DE PASSE",
                              s1: 40,
                              s2: 35,
                              color: kcPrimary,
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: newpassword,
                              obscureText: !isobsecure2,
                              validator: (value) {
                                return Validator.validatePassword(value ?? "");
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
                                labelText: "Nouveau mot de passe",
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isobsecure2 = !isobsecure2;
                                    });
                                  },
                                  icon: Icon(
                                    isobsecure2
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: kcPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: Colors.transparent),
                            TextFormField(
                              controller: retypenewpass,
                              obscureText: !isobsecure3,
                              validator: (value) {
                                return Validator.validateConfirmPassword(
                                    value ?? "", newpassword.text);
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
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isobsecure3 = !isobsecure3;
                                    });
                                  },
                                  icon: Icon(
                                    isobsecure3
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: kcPrimary,
                                  ),
                                ),
                              ),
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
                                      await cp.changePass(
                                        password: newpassword.text,
                                        retypepassword: retypenewpass.text,
                                      ).then((value) {
                                        if (value == true) {
                                          setState(() {
                                            isloading = false;
                                            Fluttertoast.showToast(
                                                msg: "Mot de passe modifié");
                                          });
                                        }
                                      });
                                      Navigator.of(context).pop();
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
                ),
                isloading ? cw.loader() : Container()
              ],
            )),
      ),
    );
  }
}
