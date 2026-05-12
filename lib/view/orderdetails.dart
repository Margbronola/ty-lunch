// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tylunch/global/color.dart';
// import 'package:tylunch/global/container.dart';
// import 'package:tylunch/global/widget.dart';
// import 'package:tylunch/model/cartprod.dart';
// import 'package:tylunch/model/new_cart_model.dart';
// import 'package:tylunch/view/payment.dart';

// class OrderDetailsPage extends StatefulWidget {
//   final List<NewCartModel> selected;
//   const OrderDetailsPage({super.key, required this.selected});

//   @override
//   State<OrderDetailsPage> createState() => _OrderDetailsPageState();
// }

// class _OrderDetailsPageState extends State<OrderDetailsPage> {
//   late final double total = getTotal();
//   final List<NewCartModel> cart = [];

//   @override
//   void initState() {
//     populateCart();
//     super.initState();
//   }

//   double getTotal() {
//     double amount = 0.0;
//     for (final NewCartModel cart in widget.selected) {
//       if (cart.products.isEmpty) {
//         // cart.subTotal = 0.0;
//       }
//       // amount = amount += cart.subTotal;
//     }
//     return amount;
//   }

//   void populateCart() async {
//     try {
//       final List<NewCartModel> carts = List.from(widget.selected);
//       for (NewCartModel c in carts) {
//         if (c.products.isNotEmpty) {
//           cart.add(
//             NewCartModel(
//               id: c.id,
//               // subTotal: c.subTotal,
//               date: c.date,
//               paymentMethod: "credit_points",
//               clientId: c.clientId,
//               products: c.products,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       cart.clear();
//     }
//     if (mounted) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         color: Colors.white,
//         child: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: size.width,
//                 height: 200,
//                 child: Stack(
//                   children: [
//                     Positioned(
//                       left: 0,
//                       top: 0,
//                       child: Image.asset(
//                         'assets/images/Layer1.png',
//                         fit: BoxFit.fitWidth,
//                         // height: 200,
//                         // width: double.infinity,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 10,
//                       left: 20,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Image.asset('assets/icons/Frame 2560.png'),
//                       ),
//                     ),
//                     const Positioned(
//                       top: 40,
//                       left: 45,
//                       child: Text(
//                         "Livraison",
//                         style: TextStyle(
//                           fontFamily: 'CraftRounded',
//                           fontSize: 30,
//                           color: kcPrimary,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 width: size.width,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomWidget()
//                             .title(t1: "A", t2: "DRESSE", s1: 37, s2: 30),
//                         const Text(
//                           "de Livraison",
//                           style: TextStyle(
//                             fontSize: 25,
//                             fontFamily: 'Ebrima',
//                           ),
//                         ),
//                       ],
//                     ),
//                     Image.asset(
//                       'assets/icons/livraison.png',
//                       fit: BoxFit.fitWidth,
//                       width: 110,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: size.width,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Divider(color: Colors.transparent),
//                     Text(
//                       "${loggedUser?.company.name}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     Text(
//                       "${loggedUser?.company.fullDelivery}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     DottedBorder(
//                       color: const Color.fromARGB(255, 139, 139, 139),
//                       dashPattern: const [5, 6],
//                       customPath: (size) {
//                         return Path()
//                           ..moveTo(0, 5)
//                           ..lineTo(size.width, 5);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: Container(),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     CustomWidget()
//                         .title(t1: "R", t2: "ÉCAPITULATIF", s1: 35, s2: 25),
//                     const Text(
//                       "de paiement",
//                       style: TextStyle(
//                         fontSize: 25,
//                       ),
//                     ),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       padding: const EdgeInsets.all(0),
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: cart.length,
//                       itemBuilder: (_, x) {
//                         return Column(
//                           children: [
//                             const SizedBox(height: 30),
//                             Text(
//                               DateFormat("MMM dd, yyyy").format((cart[x].date)),
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: const EdgeInsets.all(0),
//                               itemCount: cart[x].products.length,
//                               itemBuilder: (_, i) {
//                                 final List<CartProduct> prod = cart[x].products;
//                                 return Container(
//                                   width: size.width,
//                                   margin: const EdgeInsets.only(top: 20),
//                                   padding: const EdgeInsets.all(15),
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromARGB(
//                                         255, 245, 245, 245),
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "${prod[i].name[0].toUpperCase()}${prod[i].name.substring(1)}",
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: prod[i].isFormula
//                                                   ? FontWeight.w700
//                                                   : FontWeight.normal,
//                                             ),
//                                           ),
//                                           prod[i].isFormula
//                                               ? Text(
//                                                   "${prod[i].image}",
//                                                   style: const TextStyle(
//                                                     fontSize: 16,
//                                                   ),
//                                                 )
//                                               : Container()
//                                         ],
//                                       ),
//                                       Text(
//                                         "${prod[i].price.toStringAsFixed(2)}€",
//                                         style: const TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "Sous Total :",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 Text(
//                                   "",
//                                   // "${cart[x].subTotal.toStringAsFixed(2)}€",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 width: size.width,
//                 margin: const EdgeInsets.only(top: 40),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Total",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     Text(
//                       "${total.toStringAsFixed(2)}€",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: kcPrimary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 55,
//                 width: size.width,
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 margin: const EdgeInsets.only(top: 20, bottom: 20),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kcPrimary,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(90),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PaymentPage(
//                           selected: cart,
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "SUIVANT",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
