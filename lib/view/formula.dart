// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tylunch/global/image.dart';
import 'package:tylunch/global/network.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/formula.dart';
import 'package:tylunch/model/menu_details.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/services/database.dart';
import 'package:tylunch/viewmodel/cart.dart';

class FormulaPage extends StatefulWidget {
  FormulaModel formula;
  FormulaPage({super.key, required this.formula});

  @override
  State<FormulaPage> createState() => _FormulaPageState();
}

class _FormulaPageState extends State<FormulaPage> {
  final CartViewModel _cartViewModel = CartViewModel.instance;
  final DatabaseServices db = DatabaseServices.instance;
  final CustomWidget cw = CustomWidget();
  late final TextEditingController qty = TextEditingController()..text = '1';
  List<NewCartModel> getCart() {
    try {
      return _cartViewModel.current;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/Layer 3.png',
                      fit: BoxFit.fill,
                      width: double.maxFinite,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset('assets/icons/Frame 2560.png'),
                      ),
                    ),
                    // CustomWidget().cartQty(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       PageTransition(
                    //         child: const CartPage(),
                    //         type: PageTransitionType.rightToLeftWithFade,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: cw.title(
                          t1: widget.formula.name[0].toUpperCase(),
                          t2: widget.formula.name.substring(1).toUpperCase(),
                          s1: 40,
                          s2: 30,
                        ),
                      ),
                      Text(
                        "${widget.formula.price.toStringAsFixed(2)}€",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.formula.categories.length,
                  itemBuilder: (_, i) {
                    final List<CategorizedData> category =
                        widget.formula.categories;

                    return Container(
                      width: size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cw.title(
                            t1: category[i].name[0].toUpperCase(),
                            t2: category[i].name.substring(1).toUpperCase(),
                            s1: 33,
                            s2: 25,
                          ),
                          Container(
                            width: size.width,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: category[i].products[0].photo.isNotEmpty
                                ? CustomImageBuilder().networkBuild(context,
                                    "${Network.url}/storage/${category[i].products[0].photo[0].location}")
                                : cw.placeholder(),
                          ),
                          const Divider(color: Colors.transparent),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  category[i]
                                      .products[0]
                                      .dishName
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${category[i].products[0].price.toStringAsFixed(2)}€",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 21, 32, 146),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            "${category[i].products[0].description}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Divider(
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, i) => const Divider(
                    color: Colors.transparent,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Image.asset('assets/icons/cart.png'),
                //       const SizedBox(width: 10),
                //       GestureDetector(
                //         onTap: () async {
                //           List<NewCartModel> val = getCart();

                //           if (val.isNotEmpty) {
                //             final NewCartModel currentVal = val.first;
                //             final CartProduct cartProd = CartProduct(
                //                 isFormula: true,
                //                 image: widget.formula.fullCategory,
                //                 productId: widget.formula.id,
                //                 quantity: int.parse(qty.text.toString()),
                //                 price: widget.formula.price,
                //                 total: int.parse(qty.text.toString()) *
                //                     widget.formula.price,
                //                 name: widget.formula.name,
                //                 meals: widget.formula.categories
                //                     .map((e) => e.products.isEmpty
                //                         ? ""
                //                         : e.products[0].dishName)
                //                     .toList()
                //                     .join(', '));
                //             if (currentVal.products
                //                 .hasProduct(widget.formula.id)) {
                //               /// update
                //               await db
                //                   .updateItem(
                //                 cartId: currentVal.id,
                //                 product: cartProd,
                //               )
                //                   .whenComplete(() async {
                //                 await db.retrieve();
                //                 MyDialog().scaleDialog(
                //                   context,
                //                   child: addedtocart(),
                //                 );
                //                 if (mounted) setState(() {});
                //               });
                //               return;
                //             }
                //             await db
                //                 .addSingleItem(
                //               cartId: currentVal.id,
                //               product: cartProd,
                //             )
                //                 .whenComplete(() async {
                //               await db.retrieve();
                //               MyDialog().scaleDialog(
                //                 context,
                //                 child: addedtocart(),
                //               );
                //               if (mounted) setState(() {});
                //             });
                //           } else {
                //             // final NewCartModel toAdd = NewCartModel(
                //             //   id: DateTime.now().millisecondsSinceEpoch,
                //             //   subTotal: 0.0,
                //             //   date: DateTime.now(),
                //             //   paymentMethod: "credit",
                //             //   clientId: loggedUser!.id,
                //             //   products: [
                //             //     CartProduct(
                //             //       isFormula: true,
                //             //       image: widget.formula.fullCategory,
                //             //       productId: widget.formula.id,
                //             //       quantity: int.parse(qty.text.toString()),
                //             //       price: widget.formula.price,
                //             //       total: int.parse(qty.text.toString()) *
                //             //           widget.formula.price,
                //             //       name: widget.formula.name,
                //             //       meals: widget.formula.categories
                //             //           .map((e) => e.products.isEmpty
                //             //               ? ""
                //             //               : e.products[0].dishName)
                //             //           .toList()
                //             //           .join(','),
                //             //     )
                //             //   ],
                //             // );
                //             // await db.addItem(toAdd).whenComplete(() async {
                //             //   await db.retrieve();
                //             //   MyDialog().scaleDialog(
                //             //     context,
                //             //     child: addedtocart(),
                //             //   );
                //             //   if (mounted) setState(() {});
                //             // });
                //           }
                //         },
                //         child: const Text(
                //           "Ajouter au panier",
                //           style: TextStyle(
                //             fontSize: 15,
                //             fontWeight: FontWeight.w700,
                //             color: Color.fromARGB(255, 21, 32, 146),
                //           ),
                //         ),
                //       ),
                //       const Expanded(child: SizedBox()),
                //       const Text(
                //         "Qty. ",
                //         style: TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //       Container(
                //         width: 60,
                //         margin: const EdgeInsets.only(left: 5),
                //         child: textFormField(
                //           controller: qty,
                //           inputType: TextInputType.number,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
