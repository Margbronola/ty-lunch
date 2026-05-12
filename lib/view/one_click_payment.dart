// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/view/card_details.dart';

class OneClickPaymentPage extends StatefulWidget {
  const OneClickPaymentPage({super.key});

  @override
  State<OneClickPaymentPage> createState() => _OneClickPaymentPageState();
}

class _OneClickPaymentPageState extends State<OneClickPaymentPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    width: size.width,
                    height: 150,
                    child: Stack(
                      children: [
                        SvgPicture.asset("assets/images/circ 5.svg",
                            color: secondaryColor),
                        const Positioned(
                          top: 3,
                          left: 20,
                          child: Text(
                            "Enregistrer ma\ncarte bancaire",
                            // "Paiement\nun clic",
                            style: TextStyle(
                              fontSize: 25,
                              color: kcPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25,
                          left: 20,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset(
                              "assets/icons/chevron-left.svg",
                              height: 34,
                              width: 34,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: SizedBox(
                      height: 55,
                      width: size.width * .55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kcPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        onPressed: () async {
                          await showGeneralDialog(
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                  opacity: a1.value,
                                  child: AlertDialog(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: const Text(
                                      "Moyen de paiement",
                                      style: TextStyle(
                                        color: kcPrimary,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                      ),
                                    ),
                                    content: const CardDetailsPage(),
                                  ),
                                ),
                              );
                            },
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            barrierDismissible: true,
                            barrierLabel: '',
                            context: context,
                            pageBuilder: (context, animation1, animation2) =>
                                Container(),
                          );
                        },
                        child: const Text(
                          "AJOUTER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "REFABBONE",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 15),
                        Center(child: Text("Pas disponible")),
                        SizedBox(height: 40),
                        Text(
                          "PORTEUR",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 15),
                        Center(child: Text("Pas disponible")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
