// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/model/newcart.dart';
import 'package:tylunch/services/api/order.dart';
import 'package:tylunch/view/landing.dart';
import 'package:tylunch/view/webview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/dialog.dart';
import '../model/new_cart_model.dart';
import '../services/api/payment.dart';

class PaymentPage extends StatefulWidget {
  final List<NewCart1Model> selected;
  final List<NewCartModel> cart;
  const PaymentPage({super.key, required this.selected, required this.cart});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final TextEditingController name = TextEditingController();
  late final TextEditingController number = TextEditingController();
  late final TextEditingController expdate = TextEditingController();
  late final TextEditingController cvv = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final PaymentAPI payment = PaymentAPI();
  final OrderAPI order = OrderAPI();
  late NewCart1Model checkout;
  String outOfStockProduct = "";
  final List<String> images = [
    "assets/icons/image 4.png",
    "assets/icons/image 3.png",
    "assets/icons/image 2.png",
  ];
  final List<String> conecsimages = [
    "assets/icons/up-dejeuner.png",
    "assets/icons/bimpli.png",
    "assets/icons/pluxee.png",
    "assets/icons/edenred.png"
  ];

  // "Crédits",
  final List<String> options = ["Banque", "Titres Restaurant"];
  int? paymentIndex;
  int? conecsIndex;
  bool isloading = false;
  int title = 0;
  int index = 0;
  late int index1;
  int ind = 0;
  bool _selected = false;
  bool _selected2 = false;
  String selectedConnects = "";
  final Uri _url = Uri.parse('https://ty-lunch.fr/cgv-rgpd.html');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    for (final NewCart1Model co in widget.selected) {
      checkout = NewCart1Model(
        id: DateTime.now().millisecondsSinceEpoch,
        subTotal: co.subTotal,
        paymentMethod: "credit_points",
        clientId: loggedUser!.id,
        usePackaging: co.usePackaging,
        items: co.items,
      );
      print("TO CHECKOUT ORDERS: $checkout");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool greater = widget.selected[0].subTotal > loggedUser!.points!.toDouble();
    print("GREATER: $greater");

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formkey,
          child: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: 150,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/images/circ 5.svg",
                              color: secondaryColor,
                            ),
                            const Positioned(
                              top: 10,
                              left: 20,
                              child: Text(
                                "Paiement",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: kcPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 35,
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
                        width: size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            CustomWidget().title(
                                t1: "M",
                                t2: "OYEN DE PAIEMENT",
                                s1: 35,
                                s2: 30),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              width: size.width,
                              child: Center(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (c, i) {
                                      return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print("INDEXXXX: $i");
                                              ind = i;
                                              // if (ind == 1) {
                                              //   print(
                                              //       "PAYMENT METHOD: credit points - INDEXX: $ind");
                                              //   print(
                                              //       "PAYMENT METHOD: credit points");
                                              //   for (final NewCart1Model co
                                              //       in widget.selected) {
                                              //     checkout = NewCart1Model(
                                              //       id: DateTime.now()
                                              //           .millisecondsSinceEpoch,
                                              //       subTotal: co.subTotal,
                                              //       paymentMethod:
                                              //           "credit_points",
                                              //       clientId: loggedUser!.id,
                                              //       usePackaging:
                                              //           co.usePackaging,
                                              //       items: co.items,
                                              //     );
                                              //   }
                                              //   print(
                                              //       "TO CHECKOUT ORDERS: $checkout");
                                              // } else
                                              if (ind == 0) {
                                                print("PAYMENT METHOD: bank");
                                                for (final NewCart1Model co
                                                    in widget.selected) {
                                                  checkout = NewCart1Model(
                                                    id: DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    subTotal: co.subTotal,
                                                    paymentMethod:
                                                        loggedUser!.points ==
                                                                0.00
                                                            ? "credit_card"
                                                            : "card_points",
                                                    clientId: loggedUser!.id,
                                                    usePackaging:
                                                        co.usePackaging,
                                                    items: co.items,
                                                  );
                                                }
                                                print(
                                                    "TO CHECKOUT ORDERS: $checkout");
                                              } else {
                                                print("PAYMENT METHOD: Conecs");
                                                for (final NewCart1Model co
                                                    in widget.selected) {
                                                  checkout = NewCart1Model(
                                                    id: DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    subTotal: co.subTotal,
                                                    paymentMethod: "coneccs",
                                                    clientId: loggedUser!.id,
                                                    usePackaging:
                                                        co.usePackaging,
                                                    items: co.items,
                                                  );
                                                }
                                                print(
                                                    "TO CHECKOUT ORDERS: $checkout");
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: size.width * .4,
                                            // 150,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              border: Border.all(
                                                  color: ind == i
                                                      ? kcPrimary
                                                      : Colors.black),
                                              color: ind == i
                                                  ? kcPrimary
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                options[i],
                                                style: TextStyle(
                                                  fontSize:
                                                      // options[i] == options[1]
                                                      //     ? 12 :
                                                      14,
                                                  fontWeight: FontWeight.w600,
                                                  color: ind == i
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ));
                                    },
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 5),
                                    itemCount: options.length),
                              ),
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     ...options.map((e) {
                            //       index = options.indexOf(e);

                            //       return GestureDetector(
                            //         onTap: () {
                            //           setState(() {
                            //             print("INDEXXX: $index");
                            //             print("TITLEEE: $title");
                            // if (index == title) {
                            //   title = 0;
                            //   print(
                            //       "PAYMENT METHOD: credit points - INDEXX: $index");
                            //   print("PAYMENT METHOD: credit points");
                            //   for (final NewCart1Model co
                            //       in widget.selected) {
                            //     checkout = NewCart1Model(
                            //       id: DateTime.now()
                            //           .millisecondsSinceEpoch,
                            //       subTotal: co.subTotal,
                            //       paymentMethod: "credit_points",
                            //       clientId: loggedUser!.id,
                            //       usePackaging: co.usePackaging,
                            //       items: co.items,
                            //     );
                            //   }
                            //   print("TO CHECKOUT ORDERS: $checkout");
                            // } else {
                            //               title = index;
                            // print(
                            //     "PAYMENT METHOD: bank - INDEXX: $index");
                            // print("PAYMENT METHOD: bank");
                            // for (final NewCart1Model co
                            //     in widget.selected) {
                            //   checkout = NewCart1Model(
                            //     id: DateTime.now()
                            //         .millisecondsSinceEpoch,
                            //     subTotal: co.subTotal,
                            //     paymentMethod:
                            //         loggedUser!.points == 0.00
                            //             ? "credit_card"
                            //             : "card_points",
                            //     clientId: loggedUser!.id,
                            //     usePackaging: co.usePackaging,
                            //     items: co.items,
                            //   );
                            // }
                            // print("TO CHECKOUT ORDERS: $checkout");
                            //             }
                            //           });
                            //         },
                            //         child: Container(
                            //           width: 150,
                            //           height: 50,
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(90),
                            //             border: Border.all(
                            //                 color: title == index
                            //                     ? kcPrimary
                            //                     : Colors.black),
                            //             color: title == index
                            //                 ? kcPrimary
                            //                 : Colors.white,
                            //           ),
                            //           child: Center(
                            //             child: Text(
                            //               e,
                            //               style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w600,
                            //                 color: title == index
                            //                     ? Colors.white
                            //                     : Colors.black,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     })
                            //   ],
                            // ),
                            const SizedBox(height: 30),
                            // ind == 1
                            //     ? Column(
                            //         children: [
                            //           const SizedBox(height: 10),
                            //           const Text(
                            //             "Pour utiliser votre crédit, le panier doit être inférieur ou égal au montant de crédit disponible et à la limite de plafond journalier d’utilisation des titres-restaurant définie par la législation.",
                            //             style: TextStyle(fontSize: 14),
                            //           ),
                            //           const SizedBox(height: 15),
                            //           Row(
                            //             children: [
                            //               const Text(
                            //                 "Crédit disponible",
                            //                 style: TextStyle(
                            //                   fontSize: 20,
                            //                   fontWeight: FontWeight.w600,
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 20),
                            //               Text(
                            //                 "${loggedUser!.points!.toStringAsFixed(2)} €",
                            //                 style: const TextStyle(
                            //                   fontSize: 22,
                            //                   fontWeight: FontWeight.w700,
                            //                   color: kcPrimary,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           if (greater == true) ...{
                            //             Container(
                            //               width: 230,
                            //               height: 60,
                            //               margin:
                            //                   const EdgeInsets.only(top: 30),
                            //               decoration: BoxDecoration(
                            //                   border: Border.all(
                            //                       color: Colors.red)),
                            //               alignment: Alignment.center,
                            //               child: const Text(
                            //                 "Crédit insuffisant",
                            //                 style: TextStyle(fontSize: 18),
                            //               ),
                            //             ),
                            //           },
                            //           const SizedBox(height: 30),
                            //           Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               SizedBox(
                            //                 height: 20,
                            //                 width: 20,
                            //                 child: Checkbox(
                            //                   activeColor: kcPrimary,
                            //                   checkColor: Colors.white,
                            //                   value: _selected1,
                            //                   shape: RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.circular(4),
                            //                   ),
                            //                   side: MaterialStateBorderSide
                            //                       .resolveWith(
                            //                     (states) => const BorderSide(
                            //                         width: 1, color: kcPrimary),
                            //                   ),
                            //                   onChanged: (value) {
                            //                     setState(() {
                            //                       value == true
                            //                           ? print("selected")
                            //                           : print("unselect");
                            //                       _selected1 = value!;
                            //                     });
                            //                   },
                            //                 ),
                            //               ),
                            //               const SizedBox(width: 5),
                            //               Expanded(
                            //                 child: RichText(
                            //                   text: TextSpan(
                            //                     text: 'J’accepte les ',
                            //                     style: const TextStyle(
                            //                       color: Colors.black,
                            //                       fontWeight: FontWeight.w800,
                            //                     ),
                            //                     children: [
                            //                       TextSpan(
                            //                         text:
                            //                             "Conditions Générales de Vente",
                            //                         style: const TextStyle(
                            //                           color: kcPrimary,
                            //                           decoration: TextDecoration
                            //                               .underline,
                            //                         ),
                            //                         recognizer:
                            //                             TapGestureRecognizer()
                            //                               ..onTap = (() {
                            //                                 _launchUrl();
                            //                               }),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           Container(
                            //             height: 55,
                            //             width: 200,
                            //             margin: const EdgeInsets.only(
                            //                 bottom: 10, top: 30),
                            //             child: ElevatedButton(
                            //               style: ElevatedButton.styleFrom(
                            //                 backgroundColor: greater == true ||
                            //                         _selected1 == false
                            //                     ? Colors.grey
                            //                     : kcPrimary,
                            //                 shape: RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       BorderRadius.circular(90),
                            //                 ),
                            //               ),
                            //               onPressed: () async {
                            //                 if (greater == true) {
                            //                   print("insuffisant balance");
                            //                   Fluttertoast.showToast(
                            //                       msg: "Crédit insuffisant");
                            //                 } else if (_selected1 == false) {
                            //                   print(
                            //                       "need to accept conditions");
                            //                   Fluttertoast.showToast(
                            //                       msg:
                            //                           "accepter les conditions générales de vente");
                            //                 } else {
                            //                   setState(() {
                            //                     isloading = true;
                            //                   });
                            // await payment
                            //     .payWithPoints(
                            //         data: checkout,
                            //         ncdata: widget.cart)
                            //     .whenComplete(() {
                            //   MyDialog().scaleDialog(
                            //     context,
                            //     child: Material(
                            //       color: Colors.transparent,
                            //       elevation: 0,
                            //       child: Container(
                            //         width: 300,
                            //         height: 350,
                            //         decoration:
                            //             const BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius:
                            //               BorderRadius.only(
                            //             topLeft:
                            //                 Radius.circular(
                            //                     5),
                            //             topRight:
                            //                 Radius.circular(
                            //                     5),
                            //             bottomLeft:
                            //                 Radius.circular(
                            //                     10),
                            //             bottomRight:
                            //                 Radius.circular(
                            //                     10),
                            //           ),
                            //         ),
                            //                           child: Column(
                            //                             mainAxisAlignment:
                            //                                 MainAxisAlignment
                            //                                     .center,
                            //                             children: [
                            //                               const SizedBox(
                            //                                   height: 15),
                            //                               SvgPicture.asset(
                            //                                 "assets/icons/Frame 2612.svg",
                            //                               ),
                            //                               const SizedBox(
                            //                                   height: 20),
                            //                               const Center(
                            //                                 child: Text(
                            //                                   "Paiement terminé",
                            //                                   style: TextStyle(
                            //                                       fontSize: 30,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .w800,
                            //                                       color:
                            //                                           kcPrimary),
                            //                                 ),
                            //                               ),
                            //                               const SizedBox(
                            //                                   height: 30),
                            //                               Container(
                            //                                 height: 55,
                            //                                 width:
                            //                                     size.width * 7,
                            //                                 padding:
                            //                                     const EdgeInsets
                            //                                         .symmetric(
                            //                                         horizontal:
                            //                                             15),
                            //                                 child:
                            //                                     ElevatedButton(
                            //                                   style:
                            //                                       ElevatedButton
                            //                                           .styleFrom(
                            //                                     backgroundColor:
                            //                                         kcPrimary,
                            //                                     shape:
                            //                                         RoundedRectangleBorder(
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   90),
                            //                                     ),
                            //                                   ),
                            //                                   onPressed: () {
                            //                                     Navigator.of(
                            //                                             context)
                            //                                         .pushNamedAndRemoveUntil(
                            //                                             '/landing_page',
                            //                                             (Route<dynamic>
                            //                                                     route) =>
                            //                                                 false);
                            //                                   },
                            //                                   child: Text(
                            //                                     "Retour à l’accueil"
                            //                                         .toUpperCase(),
                            //                                     style:
                            //                                         const TextStyle(
                            //                                       color: Colors
                            //                                           .white,
                            //                                       fontSize: 16,
                            //                                       fontWeight:
                            //                                           FontWeight
                            //                                               .w800,
                            //                                     ),
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     );
                            //                   });
                            //                   if (mounted) {
                            //                     setState(() {
                            //                       isloading = false;
                            //                     });
                            //                   }
                            //                 }
                            //               },
                            //               child: const Text(
                            //                 "CONFIRMER",
                            //                 style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16,
                            //                   fontWeight: FontWeight.w600,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       )
                            //     :
                            ind == 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Crédit disponible",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            "${loggedUser!.points!.toStringAsFixed(2)} €",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: kcPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Cartes acceptées",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: Wrap(
                                          children: [
                                            ...images.map((e) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: 100,
                                                    height: 70,
                                                    color: const Color.fromARGB(
                                                        255, 245, 245, 245),
                                                    child: Center(
                                                      child: Image.asset(e),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(
                                              activeColor: kcPrimary,
                                              checkColor: Colors.white,
                                              value: _selected,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              side: MaterialStateBorderSide
                                                  .resolveWith(
                                                (states) => const BorderSide(
                                                    width: 1, color: kcPrimary),
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
                                                    text:
                                                        "Conditions Générales de Vente",
                                                    style: const TextStyle(
                                                      color: kcPrimary,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = (() {
                                                            _launchUrl();
                                                          }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      Center(
                                        child: SizedBox(
                                          height: 55,
                                          width: 200,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _selected == false
                                                      ? Colors.grey
                                                      : kcPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                              ),
                                            ),
                                            onPressed: _selected == false
                                                ? () {
                                                    print(
                                                        "need to accept conditions");
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "accepter les conditions générales de vente");
                                                  }
                                                : () async {
                                                    loggedUser!.points !=
                                                                0.00 &&
                                                            greater == false
                                                        ? await payment
                                                            .payWithPoints(
                                                                data: checkout,
                                                                ncdata:
                                                                    widget.cart)
                                                            .whenComplete(
                                                            () {
                                                              MyDialog()
                                                                  .scaleDialog(
                                                                context,
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 300,
                                                                    height: 350,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .only(
                                                                        topLeft:
                                                                            Radius.circular(5),
                                                                        topRight:
                                                                            Radius.circular(5),
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                        bottomRight:
                                                                            Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        // : loggedUser!.points !=
                                                        //             0.00 &&
                                                        //         greater == true
                                                        //     ? await payment
                                                        //         .payWithBankAndPoints(
                                                        //             data:
                                                        //                 checkout)
                                                        //         .then(
                                                        //         (value) {
                                                        //           if (value !=
                                                        //               null) {
                                                        //             print(
                                                        //                 "HTML DOCUMENTS");
                                                        //             print(
                                                        //                 "PAY WITH BANK AND POINTS: $value");
                                                        //             if (value.contains(
                                                        //                     "not_enough_quantity") ||
                                                        //                 value.contains(
                                                        //                     "false")) {
                                                        //               for (NewCartModel newcart
                                                        //                   in widget
                                                        //                       .cart) {
                                                        //                 print(
                                                        //                     "sumulod sine na condition");
                                                        //                 for (CartProduct cp
                                                        //                     in newcart.products) {
                                                        //                   print(
                                                        //                       "sumulod sine na condition 1");
                                                        //                   if (value.contains(cp
                                                        //                       .productId
                                                        //                       .toString())) {
                                                        //                     print("sumulod sine na condition 2");
                                                        //                     print("PRODUCT ID: ${cp.productId} = $value");
                                                        //                     outOfStockProduct =
                                                        //                         cp.name;
                                                        //                   }
                                                        //                 }
                                                        //               }
                                                        //               MyDialog()
                                                        //                   .scaleDialog(
                                                        //                 context,
                                                        //                 child:
                                                        //                     Material(
                                                        //                   color:
                                                        //                       Colors.transparent,
                                                        //                   elevation:
                                                        //                       0,
                                                        //                   child:
                                                        //                       Container(
                                                        //                     width:
                                                        //                         double.infinity,
                                                        //                     height:
                                                        //                         double.infinity,
                                                        //                     decoration:
                                                        //                         const BoxDecoration(
                                                        //                       color: Colors.white,
                                                        //                     ),
                                                        //                     child:
                                                        //                         Padding(
                                                        //                       padding: const EdgeInsets.all(30),
                                                        //                       child: Column(
                                                        //                         mainAxisAlignment: MainAxisAlignment.center,
                                                        //                         children: [
                                                        //                           const SizedBox(height: 20),
                                                        //                           Center(
                                                        //                             child: Text(
                                                        //                               "Pas assez de quantité pour: $outOfStockProduct",
                                                        //                               textAlign: TextAlign.center,
                                                        //                               style: const TextStyle(fontSize: 18, color: kcPrimary),
                                                        //                             ),
                                                        //                           ),
                                                        //                           const SizedBox(height: 40),
                                                        //                           Container(
                                                        //                             height: 55,
                                                        //                             width: 300,
                                                        //                             padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        //                             child: ElevatedButton(
                                                        //                               style: ElevatedButton.styleFrom(
                                                        //                                 backgroundColor: kcPrimary,
                                                        //                                 shape: RoundedRectangleBorder(
                                                        //                                   borderRadius: BorderRadius.circular(90),
                                                        //                                 ),
                                                        //                               ),
                                                        //                               onPressed: () {
                                                        //                                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LandingPage(ind: 2)), (Route<dynamic> route) => false);
                                                        //                               },
                                                        //                               child: Text(
                                                        //                                 "annuler".toUpperCase(),
                                                        //                                 style: const TextStyle(
                                                        //                                   color: Colors.white,
                                                        //                                   fontSize: 14,
                                                        //                                 ),
                                                        //                               ),
                                                        //                             ),
                                                        //                           ),
                                                        //                         ],
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                 ),
                                                        //               );
                                                        //             } else {
                                                        //               print(
                                                        //                   "HTML DOCUMENTS");
                                                        //               debugPrint(
                                                        //                   "RETURN FROM PAYMENT: $value");
                                                        //               var document =
                                                        //                   parse(
                                                        //                       value);
                                                        //               debugPrint(
                                                        //                   "HTML DOC : ${document.outerHtml}");
                                                        //               Navigator
                                                        //                   .push(
                                                        //                 context,
                                                        //                 MaterialPageRoute(
                                                        //                   builder: (context) =>
                                                        //                       WebViewPage(
                                                        //                     htmlpage:
                                                        //                         document.outerHtml,
                                                        //                     cart:
                                                        //                         widget.cart,
                                                        //                     selectedconnecs:
                                                        //                         selectedConnects,
                                                        //                   ),
                                                        //                 ),
                                                        //               );
                                                        //             }
                                                        //           }
                                                        //         },
                                                        //       )
                                                        : await payment
                                                            .payWithBank(
                                                                data: checkout)
                                                            .then((value) {
                                                            if (value != null) {
                                                              print(
                                                                  "HTML DOCUMENTS");
                                                              if (value.contains(
                                                                      "not_enough_quantity") ||
                                                                  value.contains(
                                                                      "false")) {
                                                                print(
                                                                    "PAY WITH BANK: $value");
                                                                for (NewCartModel newcart
                                                                    in widget
                                                                        .cart) {
                                                                  print(
                                                                      "sumulod sine na condition");
                                                                  for (CartProduct cp
                                                                      in newcart
                                                                          .products) {
                                                                    print(
                                                                        "sumulod sine na condition 1");
                                                                    if (value.contains(cp
                                                                        .productId
                                                                        .toString())) {
                                                                      print(
                                                                          "sumulod sine na condition 2");
                                                                      print(
                                                                          "PRODUCT ID: ${cp.productId} = $value");
                                                                      outOfStockProduct =
                                                                          cp.name;
                                                                    }
                                                                  }
                                                                }
                                                                MyDialog()
                                                                    .scaleDialog(
                                                                  context,
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    elevation:
                                                                        0,
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height: double
                                                                          .infinity,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            30),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            const SizedBox(height: 20),
                                                                            Center(
                                                                              child: Text(
                                                                                "Pas assez de quantité pour: $outOfStockProduct",
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(fontSize: 18, color: kcPrimary),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 40),
                                                                            Container(
                                                                              height: 55,
                                                                              width: 300,
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: kcPrimary,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(90),
                                                                                  ),
                                                                                ),
                                                                                onPressed: () {
                                                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LandingPage(ind: 2)), (Route<dynamic> route) => false);
                                                                                },
                                                                                child: Text(
                                                                                  "annuler".toUpperCase(),
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
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
                                                              } else {
                                                                debugPrint(
                                                                    "RETURN FROM PAYMENT: $value");
                                                                var document =
                                                                    parse(
                                                                        value);
                                                                debugPrint(
                                                                    "HTML DOC : ${document.outerHtml}");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            WebViewPage(
                                                                      htmlpage:
                                                                          document
                                                                              .outerHtml,
                                                                      cart: widget
                                                                          .cart,
                                                                      selectedconnecs:
                                                                          selectedConnects,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          });
                                                  },
                                            child: const Text(
                                              "CONFIRMER",
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
                                        height: 55,
                                        width: size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "ANNULER",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Pour utiliser votre titre-restaurant, le panier doit être inférieur ou égal à la limite de plafond journalier d’utilisation des titres-restaurant définie par la législation.",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text(
                                            "Crédit disponible",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(
                                            "${loggedUser!.points!.toStringAsFixed(2)} €",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: kcPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        "Sélectionnez votre titre-restaurant parmi les cartes acceptées",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                        child: Wrap(
                                          children: [
                                            ...conecsimages.map((e) {
                                              final int index1 =
                                                  conecsimages.indexOf(e);
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    conecsIndex = index1;
                                                    if (index1 == 0) {
                                                      selectedConnects =
                                                          "UPCHEQUDEJ";
                                                      print(
                                                          "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                                                    } else if (index1 == 1) {
                                                      selectedConnects =
                                                          "APETIZ";
                                                      print(
                                                          "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                                                    } else if (index1 == 2) {
                                                      selectedConnects =
                                                          "SODEXO";
                                                      print(
                                                          "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                                                    } else {
                                                      selectedConnects =
                                                          "edenred";
                                                      print(
                                                          "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                                                    }
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                        width: 110,
                                                        height: 70,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        color: conecsIndex ==
                                                                index1
                                                            ? kcPrimary
                                                            : const Color
                                                                .fromARGB(255,
                                                                245, 245, 245),
                                                        child: Center(
                                                          child: Image.asset(e),
                                                        )),
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(
                                              activeColor: kcPrimary,
                                              checkColor: Colors.white,
                                              value: _selected2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              side: MaterialStateBorderSide
                                                  .resolveWith(
                                                (states) => const BorderSide(
                                                    width: 1, color: kcPrimary),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  value == true
                                                      ? print("selected")
                                                      : print("unselect");
                                                  _selected2 = value!;
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
                                                    text:
                                                        "Conditions Générales de Vente",
                                                    style: const TextStyle(
                                                      color: kcPrimary,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = (() {
                                                            _launchUrl();
                                                          }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      Center(
                                        child: SizedBox(
                                          height: 55,
                                          width: 200,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _selected2 == false ||
                                                          conecsIndex == null
                                                      ? Colors.grey
                                                      : kcPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(90),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (_selected2 == false) {
                                                print(
                                                    "need to accept conditions");
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "accepter les conditions générales de vente");
                                              } else if (conecsIndex == null) {
                                                print("need to select cards");
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "choisissez parmi les cartes acceptées");
                                              } else {
                                                await payment
                                                    .payWithConecs(
                                                        data: checkout,
                                                        selectedConnects:
                                                            selectedConnects)
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      print("HTML DOCUMENTS");
                                                      print(
                                                          "PAY WITH CONNECS: $value");
                                                      if (value.contains(
                                                              "not_enough_quantity") ||
                                                          value.contains(
                                                              "false")) {
                                                        for (NewCartModel newcart
                                                            in widget.cart) {
                                                          print(
                                                              "sumulod sine na condition");
                                                          for (CartProduct cp
                                                              in newcart
                                                                  .products) {
                                                            print(
                                                                "sumulod sine na condition 1");
                                                            if (value.contains(cp
                                                                .productId
                                                                .toString())) {
                                                              print(
                                                                  "sumulod sine na condition 2");
                                                              print(
                                                                  "PRODUCT ID: ${cp.productId} = $value");
                                                              outOfStockProduct =
                                                                  cp.name;
                                                            }
                                                          }
                                                        }
                                                        MyDialog().scaleDialog(
                                                          context,
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            elevation: 0,
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        30),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "Pas assez de quantité pour: $outOfStockProduct",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                kcPrimary),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            40),
                                                                    Container(
                                                                      height:
                                                                          55,
                                                                      width:
                                                                          300,
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              kcPrimary,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(90),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pushAndRemoveUntil(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => LandingPage(ind: 2)),
                                                                              (Route<dynamic> route) => false);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "annuler"
                                                                              .toUpperCase(),
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            // fontWeight: FontWeight.w800,
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
                                                      } else {
                                                        print("HTML DOCUMENTS");
                                                        debugPrint(
                                                            "RETURN FROM PAYMENT: $value");
                                                        var document =
                                                            parse(value);
                                                        debugPrint(
                                                            "HTML DOC : ${document.outerHtml}");
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    WebViewPage(
                                                              htmlpage: document
                                                                  .outerHtml,
                                                              cart: widget.cart,
                                                              selectedconnecs:
                                                                  selectedConnects,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "CONFIRMER",
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
                                        height: 55,
                                        width: size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "ANNULER",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            //  Column(
                            //     crossAxisAlignment:
                            //         CrossAxisAlignment.start,
                            //     children: [
                            //       const Text(
                            //         "Pour utiliser votre titre-restaurant, le panier doit être inférieur ou égal à la limite de plafond journalier d’utilisation des titres-restaurant définie par la législation.",
                            //         style: TextStyle(fontSize: 14),
                            //       ),
                            //       const SizedBox(height: 20),
                            //       Row(
                            //         children: [
                            //           const Text(
                            //             "Crédit disponible",
                            //             style: TextStyle(
                            //               fontSize: 20,
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //           const SizedBox(width: 20),
                            //           Text(
                            //             "${loggedUser!.points!.toStringAsFixed(2)} €",
                            //             style: const TextStyle(
                            //               fontSize: 22,
                            //               fontWeight: FontWeight.w700,
                            //               color: kcPrimary,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 20),
                            //       const Text(
                            //         "Cartes acceptées",
                            //         style: TextStyle(
                            //           fontSize: 16,
                            //           fontWeight: FontWeight.w700,
                            //         ),
                            //       ),
                            //       const SizedBox(height: 10),
                            //       // Container(
                            //       //   alignment: Alignment.center,
                            //       //   margin: const EdgeInsets.all(10),
                            //       //   child: Image.asset(
                            //       //       "assets/icons/image 1.png"),
                            //       // ),
                            //       Center(
                            //         child: Wrap(
                            //           children: [
                            //             ...conecsimages.map((e) {
                            //               final int index1 =
                            //                   conecsimages.indexOf(e);
                            //               return GestureDetector(
                            //                 onTap: () {
                            //                   setState(() {
                            //                     //   if (index1 ==
                            //                     //       conecsIndex) {
                            //                     //     conecsIndex = null;
                            //                     //   } else {
                            //                     //     conecsIndex = index1;
                            //                     //   }
                            //                     conecsIndex = index1;
                            //                     if (index1 == 0) {
                            //                       selectedConnects =
                            //                           "UPCHEQUDEJ";
                            //                       print(
                            //                           "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                            //                     } else if (index1 ==
                            //                         1) {
                            //                       selectedConnects =
                            //                           "APETIZ";
                            //                       print(
                            //                           "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                            //                     } else {
                            //                       selectedConnects =
                            //                           "SODEXO";
                            //                       print(
                            //                           "INDEXX1 CODE: $index1  - SELECTED CONNECS: $selectedConnects");
                            //                     }
                            //                   });
                            //                 },
                            //                 child: Padding(
                            //                   padding:
                            //                       const EdgeInsets.all(
                            //                           5),
                            //                   child: ClipRRect(
                            //                     borderRadius:
                            //                         BorderRadius
                            //                             .circular(10),
                            //                     child: Container(
                            //                         width: 110,
                            //                         height: 70,
                            //                         padding:
                            //                             const EdgeInsets
                            //                                 .all(5),
                            //                         color: conecsIndex ==
                            //                                 index1
                            //                             ? kcPrimary
                            //                             : const Color
                            //                                 .fromARGB(
                            //                                 255,
                            //                                 245,
                            //                                 245,
                            //                                 245),
                            //                         child: Center(
                            //                           child:
                            //                               Image.asset(
                            //                                   e),
                            //                         )),
                            //                   ),
                            //                 ),
                            //               );
                            //             }),
                            //           ],
                            //         ),
                            //       ),
                            //       // CustomWidget().tf1(
                            //       //     controller: name,
                            //       //     name: "Nom du titulaire",
                            //       //     size: 16),
                            //       // const Divider(color: Colors.transparent),
                            //       // CustomWidget().tf1(
                            //       //     controller: name,
                            //       //     name: "Numéro de carte",
                            //       //     size: 16),
                            //       // const Divider(color: Colors.transparent),
                            //       // Row(
                            //       //   mainAxisAlignment:
                            //       //       MainAxisAlignment.spaceBetween,
                            //       //   children: [
                            //       //     Expanded(
                            //       //       child: CustomWidget().tf1(
                            //       //           controller: name,
                            //       //           name: "Date Expiration",
                            //       //           size: 16),
                            //       //     ),
                            //       //     const SizedBox(width: 20),
                            //       //     Expanded(
                            //       //       child: CustomWidget().tf1(
                            //       //           controller: name,
                            //       //           name: "CVC",
                            //       //           size: 16),
                            //       //     ),
                            //       //   ],
                            //       // ),
                            //       const SizedBox(height: 30),
                            //       Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.center,
                            //         children: [
                            //           SizedBox(
                            //             height: 20,
                            //             width: 20,
                            //             child: Checkbox(
                            //               activeColor: kcPrimary,
                            //               checkColor: Colors.white,
                            //               value: _selected,
                            //               shape: RoundedRectangleBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(
                            //                         4),
                            //               ),
                            //               side: MaterialStateBorderSide
                            //                   .resolveWith(
                            //                 (states) =>
                            //                     const BorderSide(
                            //                         width: 1,
                            //                         color: kcPrimary),
                            //               ),
                            //               onChanged: (value) {
                            //                 setState(() {
                            //                   value == true
                            //                       ? print("selected")
                            //                       : print("unselect");
                            //                   _selected = value!;
                            //                 });
                            //               },
                            //             ),
                            //           ),
                            //           const SizedBox(width: 5),
                            //           Expanded(
                            //             child: RichText(
                            //               text: TextSpan(
                            //                 text: 'J’accepte les ',
                            //                 style: const TextStyle(
                            //                   color: Colors.black,
                            //                   fontWeight:
                            //                       FontWeight.w800,
                            //                 ),
                            //                 children: [
                            //                   TextSpan(
                            //                     text:
                            //                         "Conditions Générales de Vente",
                            //                     style: const TextStyle(
                            //                       color: kcPrimary,
                            //                       decoration:
                            //                           TextDecoration
                            //                               .underline,
                            //                     ),
                            //                     recognizer:
                            //                         TapGestureRecognizer()
                            //                           ..onTap = (() {
                            //                             _launchUrl();
                            //                           }),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //       const SizedBox(height: 30),
                            //       Center(
                            //         child: SizedBox(
                            //           height: 55,
                            //           width: 200,
                            //           child: ElevatedButton(
                            //             style: ElevatedButton.styleFrom(
                            //               backgroundColor: kcPrimary,
                            //               shape: RoundedRectangleBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(
                            //                         90),
                            //               ),
                            //             ),
                            //             onPressed: () async {
                            //               // if (_formkey.currentState!
                            //               //     .validate()) {
                            //               //   setState(() {
                            //               //     isloading = true;
                            //               //   });

                            //               await payment
                            //                   .payWithConecs(
                            //                       data: checkout,
                            //                       selectedConnects:
                            //                           selectedConnects)
                            //                   .then((value) {
                            //                 if (value != null) {
                            //                   print("HTML DOCUMENTS");
                            //                   debugPrint(
                            //                       "RETURN FROM PAYMENT: $value");
                            //                   var document =
                            //                       parse(value);
                            //                   debugPrint(
                            //                       "HTML DOC : ${document.outerHtml}");
                            //                   Navigator.push(
                            //                     context,
                            //                     MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           WebViewPage(
                            //                         htmlpage: document
                            //                             .outerHtml,
                            //                         cart: widget.cart,
                            //                       ),
                            //                     ),
                            //                   );
                            //                 }
                            //               });
                            //             },
                            //             child: const Text(
                            //               "CONFIRMER",
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w600,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 55,
                            //         width: size.width,
                            //         margin: const EdgeInsets.only(
                            //             bottom: 10),
                            //         child: MaterialButton(
                            //           onPressed: () {
                            //             Navigator.pop(context);
                            //           },
                            //           child: const Text(
                            //             "ANNULER",
                            //             style: TextStyle(
                            //               color: Colors.black,
                            //               fontSize: 16,
                            //               fontWeight: FontWeight.w600,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isloading ? CustomWidget().loader() : Container()
            ],
          ),
        ),
      ),
    );
  }
}
