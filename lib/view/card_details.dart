// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/services/api/payment.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({super.key});

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage>  {
  late final TextEditingController number = TextEditingController();
  late final TextEditingController expdate = TextEditingController();
  late final TextEditingController cvv = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final PaymentAPI payment = PaymentAPI();
  late bool _selected = false;
  int? paymentIndex;

  final List<String> images = [
    "assets/icons/image 4.png",
    "assets/icons/image 3.png",
    "assets/icons/image 2.png",
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * .8),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sélectionnez la carte",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kcPrimary),
                ),
                Center(
                  child: Wrap(
                    children: [
                      ...images.map((e) {
                        final int index1 = images.indexOf(e);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index1 == paymentIndex) {
                                paymentIndex = null;
                              } else {
                                paymentIndex = index1;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 70,
                                height: 50,
                                color: paymentIndex == index1
                                    ? kcPrimary
                                    : const Color.fromARGB(255, 245, 245, 245),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(e),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomWidget().tf1(controller: number, name: "Numéro de carte"),
                const Divider(color: Colors.transparent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomWidget().tf1(
                          controller: expdate,
                          name: "Date Expiration",
                          hintlabel: "MM/AA"),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomWidget().tf1(controller: cvv, name: "CVC"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(
                      height: 25,
                      width: 25,
                      child: Checkbox(
                        activeColor: kcPrimary,
                        checkColor: Colors.white,
                        value: _selected,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: MaterialStateBorderSide.resolveWith(
                          (states) =>
                              const BorderSide(width: 1, color: kcPrimary),
                        ),
                        onChanged: (value) {
                          setState(() {
                            value == true
                                ? print("selected")
                                : print("unselect");
                            _selected = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'J’accepte les ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            TextSpan(
                              text: "Conditions Générales de Vente",
                              style: const TextStyle(
                                color: kcPrimary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (() {
                                  // Navigator.push(
                                  //   context,
                                  //   PageTransition(
                                  //     child:
                                  //         const RegistrationPage(),
                                  //     type: PageTransitionType
                                  //         .leftToRight,
                                  //   ),
                                  // );
                                }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Center(
                  child: SizedBox(
                    height: 55,
                    width: size.width * 7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kcPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90)),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          await payment.addCard(
                                  card: number.text,
                                  cvv: cvv.text,
                                  expiry: expdate.text)
                              .then((value) {
                            print("PRINT VALUE: $value");
                          });
                        }
                      },
                      child: const Text(
                        "CONFIRMER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 55,
                  width: size.width,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "ANNULER",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
