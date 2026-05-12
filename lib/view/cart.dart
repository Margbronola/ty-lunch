// ignore_for_file: avoid_print, unrelated_type_equality_checks, deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tylunch/model/product.dart';
import 'package:tylunch/model/cartformula.dart';
import 'package:tylunch/model/cartprod1.dart';
import 'package:tylunch/model/item.dart';
import 'package:tylunch/services/database.dart';
import 'package:tylunch/view/payment.dart';
import 'package:tylunch/view/paymentsuccessful.dart';
import 'package:tylunch/view/qty.dart';
import 'package:tylunch/viewmodel/product.dart';
import '../global/color.dart';
import '../global/container.dart';
import '../global/widget.dart';
import '../model/cartprod.dart';
import '../model/categories.dart';
import '../model/formula.dart';
import '../model/new_cart_model.dart';
import '../model/product_regroup.dart';
import '../model/remap_formula.dart';
import '../model/remap_individual.dart';
import '../model/newcart.dart';
import '../viewmodel/cart.dart';
import '../viewmodel/product_regroup.dart';
import 'landing.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartViewModel _cartViewModel = CartViewModel.instance;
  final ProductViewModel _productVM = ProductViewModel.instance;
  final CustomWidget cw = CustomWidget();
  final ProductRegroupViewModel _prViewModel = ProductRegroupViewModel.instance;
  List<NewCart1Model> toAdd = [];
  List<NewCartModel> cart = [];
  List<ProductRegroupModel> regroupProduct = [];
  late CartProduct cartProduct;
  String name = "";
  String prodName = "";
  int prodStock = 0;
  int categoryQty = 0;
  int individualQty = 0;
  bool selected = false;
  late List<CategoriesModel> category = [];
  bool hasFormula = false;
  bool formulaIsMorethanOne = false;
  final DatabaseServices dbhandler = DatabaseServices.instance;

  @override
  void initState() {
    dbhandler.retrieve();
    _cartViewModel.stream.listen((event) {
      populateCart();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void populateCart() async {
    try {
      cart = List.from(_cartViewModel.current);
    } catch (e) {
      cart.clear();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SvgPicture.asset("assets/images/circ 5.svg",
                    color: secondaryColor),
                const Positioned(
                  top: 8,
                  left: 15,
                  child: Text(
                    "Mon panier",
                    style: TextStyle(
                        fontSize: 30,
                        color: kcPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<List<ProductRegroupModel>>(
                    stream: _prViewModel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !snapshot.hasError) {
                        if (snapshot.data!.isNotEmpty) {
                          final List<ProductRegroupModel> result =
                              snapshot.data!;
                          regroupProduct = result;

                          return Column(
                            children: [
                              Container(
                                width: size.width,
                                height: 40,
                                color: secondaryColor.withOpacity(.3),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: SizedBox()),
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        "Prix unitaire TTC",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        "Qté",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        "Montant TTC",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              StreamBuilder<List<NewCartModel>>(
                                stream: _cartViewModel.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && !snapshot.hasError) {
                                    if (snapshot.data!.isNotEmpty) {
                                      final List<NewCartModel> cart =
                                          snapshot.data!;

                                      return ListView(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemBuilder: (c, i) {
                                              final ProductRegroupModel data =
                                                  result[i];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      DateFormat("EEEE dd MMMM",
                                                              'fr_FR')
                                                          .format(
                                                              DateTime.parse(
                                                                  data.date)),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kcPrimary,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    StreamBuilder<
                                                            List<ProductModel>>(
                                                        stream:
                                                            _productVM.stream,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .hasData &&
                                                              !snapshot
                                                                  .hasError) {
                                                            if (snapshot.data!
                                                                .isNotEmpty) {
                                                              final List<
                                                                      ProductModel>
                                                                  productData =
                                                                  snapshot
                                                                      .data!;

                                                              return Column(
                                                                children: [
                                                                  data.remapFormula!
                                                                          .isEmpty
                                                                      ? Container()
                                                                      : ListView
                                                                          .separated(
                                                                          shrinkWrap:
                                                                              true,
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                          itemCount: data
                                                                              .remapFormula!
                                                                              .length,
                                                                          separatorBuilder: (_, __) =>
                                                                              const SizedBox(height: 20),
                                                                          itemBuilder:
                                                                              (c, q) {
                                                                            hasFormula =
                                                                                true;
                                                                            for (final FormulaModel formula
                                                                                in formula!) {
                                                                              if (data.remapFormula!.isNotEmpty) {
                                                                                if (formula.id == data.remapFormula?[q].formulaId) {
                                                                                  name = formula.name;
                                                                                  print("FORMULA NAME: $name");
                                                                                }
                                                                              }
                                                                            }

                                                                            return Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        "Formule $name",
                                                                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 90,
                                                                                      child: Text(
                                                                                        "${data.remapFormula?[q].unitPrice.toStringAsFixed(2)} €",
                                                                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 50,
                                                                                      child: Text(
                                                                                        "${data.remapFormula?[q].qty}",
                                                                                        style: const TextStyle(
                                                                                          fontSize: 20,
                                                                                          fontWeight: FontWeight.w600,
                                                                                        ),
                                                                                        textAlign: TextAlign.center,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 70,
                                                                                      child: Text("${data.remapFormula?[q].amount.toStringAsFixed(2)} €", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                                  padding: const EdgeInsets.all(0),
                                                                                  itemCount: data.remapFormula![q].categories.length,
                                                                                  itemBuilder: (c, x) {
                                                                                    category = data.remapFormula![q].categories;
                                                                                    for (final ProductModel prod in productData) {
                                                                                      if (prod.id == category[x].prodId) {
                                                                                        return Column(
                                                                                          children: [
                                                                                            const SizedBox(height: 10),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: [
                                                                                                Expanded(
                                                                                                  child: Text(
                                                                                                    "${prod.dishName[0].toUpperCase()}${prod.dishName.substring(1)}",
                                                                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kcPrimary),
                                                                                                    maxLines: 2,
                                                                                                  ),
                                                                                                ),
                                                                                                const SizedBox(width: 90),
                                                                                                GestureDetector(
                                                                                                  onTap: () {
                                                                                                    print("PROD IN CART: $prod");
                                                                                                    for (final CartProduct cprod in cart[i].products) {
                                                                                                      if (cprod.productId == data.remapFormula![q].categories[x].prodId) {
                                                                                                        cartProduct = cprod;
                                                                                                        print("CART PRODUCT: $cartProduct");
                                                                                                        if (data.remapIndividual!.isNotEmpty) {
                                                                                                          for (final RemapIndividualModel remapIndi in data.remapIndividual!) {
                                                                                                            if (cartProduct.productId == remapIndi.prodId) {
                                                                                                              individualQty = remapIndi.qty;
                                                                                                              print("mayda individual $individualQty");
                                                                                                              categoryQty = individualQty;
                                                                                                            }
                                                                                                          }
                                                                                                        }
                                                                                                      }
                                                                                                    }
                                                                                                    print("CATEGORY QTY: $categoryQty");
                                                                                                    print("REMAP QTY: ${data.remapFormula![q].qty} - INDIVIDUAL QTY: $individualQty");
                                                                                                    print("PRODUCTTT STOCK ON CART PAGE: ${prod.dishName} -  ${prod.stock}");

                                                                                                    showModalBottomSheet(
                                                                                                      isScrollControlled: true,
                                                                                                      backgroundColor: Colors.transparent,
                                                                                                      constraints: BoxConstraints(
                                                                                                        maxHeight: size.height,
                                                                                                      ),
                                                                                                      context: context,
                                                                                                      builder: (_) => BackdropFilter(
                                                                                                        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                                                                                        child: QtyPage(
                                                                                                          fromGeorgettes: false,
                                                                                                          hasFormula: hasFormula,
                                                                                                          fromFormula: true,
                                                                                                          label: cartProduct.name,
                                                                                                          formulaQty: data.remapFormula![q].qty,
                                                                                                          cartId: cart[i].id,
                                                                                                          cartProduct: cartProduct,
                                                                                                          date: cart[i].date.toString(),
                                                                                                          day: cartProduct.day,
                                                                                                          menuId: cartProduct.menuId,
                                                                                                          categoryId: cartProduct.categoryId,
                                                                                                          categoryQty: categoryQty,
                                                                                                          prodStock: prod.stock,
                                                                                                          individualQty: individualQty,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ).whenComplete(() {
                                                                                                      setState(() {
                                                                                                        categoryQty = 0;
                                                                                                        individualQty = 0;
                                                                                                      });
                                                                                                    });
                                                                                                  },
                                                                                                  child: SizedBox(
                                                                                                    width: 50,
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          "${data.remapFormula![q].qty}",
                                                                                                          style: const TextStyle(
                                                                                                            decoration: TextDecoration.underline,
                                                                                                            fontSize: 20,
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            color: kcPrimary,
                                                                                                          ),
                                                                                                          textAlign: TextAlign.center,
                                                                                                        ),
                                                                                                        const SizedBox(width: 5),
                                                                                                        const Text(
                                                                                                          "+/-",
                                                                                                          style: TextStyle(
                                                                                                            fontWeight: FontWeight.w600,
                                                                                                            color: kcPrimary,
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                const SizedBox(width: 70),
                                                                                              ],
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                    return Container();
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                  data.remapIndividual!
                                                                          .isEmpty
                                                                      ? Container()
                                                                      : Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: 5),
                                                                              child: Text(
                                                                                "Hors formule",
                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
                                                                            ListView.builder(
                                                                              shrinkWrap: true,
                                                                              physics: const NeverScrollableScrollPhysics(),
                                                                              padding: const EdgeInsets.all(0),
                                                                              itemCount: data.remapIndividual!.length,
                                                                              itemBuilder: (c, x) {
                                                                                final RemapIndividualModel indi = data.remapIndividual![x];
                                                                                for (final CartProduct prod in cart[i].products) {
                                                                                  if (prod.productId == indi.prodId) {
                                                                                    prodName = prod.name;
                                                                                  }
                                                                                }
                                                                                for (final ProductModel prod in productData) {
                                                                                  if (prod.id == indi.prodId) {
                                                                                    prodStock = prod.stock;
                                                                                    print("PROD STOCK IN INDIVIDUAL: $prodName - ${prod.stock} - ${prod.dishName}");
                                                                                  }
                                                                                }

                                                                                return Column(
                                                                                  children: [
                                                                                    const SizedBox(height: 5),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Text("${prodName[0].toUpperCase()}${prodName.substring(1)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kcPrimary), maxLines: 2),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 90,
                                                                                          child: Text(
                                                                                            "${indi.price.toStringAsFixed(2)} €",
                                                                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kcPrimary),
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            int remapqty = 0;
                                                                                            for (final CartProduct prod in cart[i].products) {
                                                                                              if (prod.productId == indi.prodId) {
                                                                                                cartProduct = prod;
                                                                                                if (data.remapFormula!.isNotEmpty) {
                                                                                                  for (final RemapFormulaModel remapFormula in data.remapFormula!) {
                                                                                                    for (final CategoriesModel category in remapFormula.categories) {
                                                                                                      if (prod.productId == category.prodId) {
                                                                                                        print("mayda formula");
                                                                                                        categoryQty = remapFormula.qty;
                                                                                                        remapqty = remapFormula.qty;
                                                                                                        print("CATEGORY QTY: $categoryQty");
                                                                                                        print("REMAP FORMULA QTY: $remapqty");
                                                                                                        print("INDIVIDUAL QTY: ${data.remapIndividual![x].qty}");
                                                                                                      }
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            }
                                                                                            print("PRODUCTTT STOCK ON CART PAGE: ${prodStock}");

                                                                                            showModalBottomSheet(
                                                                                              isScrollControlled: true,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              constraints: BoxConstraints(
                                                                                                maxHeight: size.height,
                                                                                              ),
                                                                                              context: context,
                                                                                              builder: (_) => BackdropFilter(
                                                                                                filter: ImageFilter.blur(
                                                                                                  sigmaX: 0,
                                                                                                  sigmaY: 0,
                                                                                                ),
                                                                                                child: QtyPage(
                                                                                                  fromGeorgettes: false,
                                                                                                  hasFormula: hasFormula,
                                                                                                  fromFormula: false,
                                                                                                  label: cartProduct.name,
                                                                                                  formulaQty: remapqty,
                                                                                                  individualQty: data.remapIndividual![x].qty,
                                                                                                  categoryQty: categoryQty,
                                                                                                  cartId: cart[i].id,
                                                                                                  cartProduct: cartProduct,
                                                                                                  prodStock: prodStock,
                                                                                                  date: cart[i].date.toString(),
                                                                                                  day: cartProduct.day,
                                                                                                  menuId: cartProduct.menuId,
                                                                                                  categoryId: cartProduct.categoryId,
                                                                                                ),
                                                                                              ),
                                                                                            ).whenComplete(() {
                                                                                              setState(() {
                                                                                                categoryQty = 0;
                                                                                                individualQty = 0;
                                                                                              });
                                                                                            });
                                                                                          },
                                                                                          child: SizedBox(
                                                                                            width: 50,
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  "${indi.qty}",
                                                                                                  style: const TextStyle(
                                                                                                    decoration: TextDecoration.underline,
                                                                                                    fontSize: 20,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: kcPrimary,
                                                                                                  ),
                                                                                                  textAlign: TextAlign.center,
                                                                                                ),
                                                                                                const SizedBox(width: 5),
                                                                                                const Text(
                                                                                                  "+/-",
                                                                                                  style: TextStyle(
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: kcPrimary,
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 70,
                                                                                          child: Text("${indi.total.toStringAsFixed(2)} €",
                                                                                              style: const TextStyle(
                                                                                                fontSize: 16,
                                                                                                fontWeight: FontWeight.w600,
                                                                                                color: kcPrimary,
                                                                                              ),
                                                                                              textAlign: TextAlign.center),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ],
                                                                        )
                                                                ],
                                                              );
                                                            }
                                                          }
                                                          return Container();
                                                        }),

                                                    // data.remapIndividual!
                                                    //         .isEmpty
                                                    //     ? Container()
                                                    // : Column(

                                                    //             ],
                                                    //           );
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 15),
                                                      child: cw.divider(num: 6),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Sous-total du ${DateFormat("dd").format(DateTime.parse(data.date))}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: kcPrimary,
                                                          ),
                                                        ),
                                                        Text(
                                                          " ${cart[i].subTotal.toStringAsFixed(2)} €",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: kcPrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 30),
                                            itemCount: result.length,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                            child: Divider(
                                              color: Colors.black,
                                              thickness: 1,
                                              height: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "TOTAL COMMANDE",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: kcPrimary,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${total.toStringAsFixed(2)} €",
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: kcPrimary,
                                                        ),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemBuilder: (c, i) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "A livrer le ${DateFormat("dd MMMM", 'fr_FR').format(cart[i].date)}",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: kcPrimary,
                                                            ),
                                                          ),
                                                          Text(
                                                            " ${cart[i].subTotal.toStringAsFixed(2)} €",
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: kcPrimary,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    separatorBuilder: (_, __) =>
                                                        const SizedBox(
                                                            height: 5),
                                                    itemCount: cart.length),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }
                                  return Container();
                                },
                              ),
                              const SizedBox(height: 30),
                              Image.asset(
                                'assets/images/consigne.png',
                                width: 200,
                                fit: BoxFit.fitWidth,
                              ),
                              const Text(
                                "Contenants",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  color: kcPrimary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset("assets/icons/info.svg"),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      "Nos repas sont livrés dans des contenants réutilisables que nous récupérons.",
                                      style: TextStyle(
                                        color: kcPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Image.asset('assets/images/images.png',
                                  fit: BoxFit.fitWidth),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      activeColor: kcPrimary,
                                      checkColor: Colors.white,
                                      value: selected,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => const BorderSide(
                                            width: 1, color: kcPrimary),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          value == true
                                              ? print("selected")
                                              : print("unselect");
                                          selected = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  const Expanded(
                                    child: Text(
                                      "  Je préfère un emballage à usage unique",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LandingPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/cart.png',
                                        color: kcPrimary, width: 25),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Poursuivre ma commande",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: kcPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 55,
                                width: size.width * .7,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: yellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(90),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final List<CartFormula> cf = [];
                                    final List<CartProduct1> cp = [];
                                    print("CART DATA: $cart");
                                    print("PRODUCT REGROUP: $regroupProduct");

                                    for (final NewCartModel cart1 in cart) {
                                      for (final ProductRegroupModel prm
                                          in regroupProduct) {
                                        if (DateFormat('EEEE', 'fr_FR').format(
                                                DateTime.parse(
                                                    cart1.date.toString())) ==
                                            DateFormat('EEEE', 'fr_FR').format(
                                                DateTime.parse(prm.date))) {
                                          for (int i = 0;
                                              i < prm.remapIndividual!.length;
                                              i++) {
                                            cp.add(CartProduct1(
                                              productId: prm
                                                  .remapIndividual![i].prodId,
                                              amount:
                                                  prm.remapIndividual![i].total,
                                              date:
                                                  prm.remapIndividual![i].date,
                                              qty: prm.remapIndividual![i].qty,
                                              unitPrice:
                                                  prm.remapIndividual![i].price,
                                              menuId: prm
                                                  .remapIndividual![i].menuId,
                                              categoryId: prm
                                                  .remapIndividual![i]
                                                  .categoryId,
                                            ));
                                          }
                                          for (int j = 0;
                                              j < prm.remapFormula!.length;
                                              j++) {
                                            cf.add(
                                              CartFormula(
                                                amount:
                                                    prm.remapFormula![j].amount,
                                                categories: prm.remapFormula![j]
                                                    .categories,
                                                date: prm.remapFormula![j].date,
                                                formulaId: prm
                                                    .remapFormula![j].formulaId,
                                                qty: prm.remapFormula![j].qty,
                                                unitPrice: prm
                                                    .remapFormula![j].unitPrice,
                                              ),
                                            );
                                          }

                                          toAdd.add(NewCart1Model(
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            subTotal: cart1.subTotal,
                                            paymentMethod: null,
                                            clientId: loggedUser!.id,
                                            usePackaging:
                                                selected == true ? 1 : 0,
                                            items: [
                                              ItemModel(
                                                cartformula: cf,
                                                cartproduct: cp,
                                              ),
                                            ],
                                          ));

                                          print("ADD ALL $toAdd");
                                        } else {
                                          print("diri");
                                        }
                                      }
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                          selected: toAdd,
                                          cart: cart,
                                        ),
                                      ),
                                    ).whenComplete(() {
                                      setState(() {
                                        toAdd.clear();
                                      });
                                    });
                                  },
                                  child: const Text(
                                    "VERS LE PAIEMENT",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                      }
                      return Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            SvgPicture.asset(
                              "assets/images/cart.svg",
                              color: const Color.fromARGB(255, 230, 230, 230),
                            ),
                            const Divider(color: Colors.transparent),
                            const Text(
                              "Un petit creux ?",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text("Oups, votre panier est vide...",
                                style: TextStyle(fontSize: 15)),
                            Container(
                              height: 60,
                              width: size.width * .7,
                              margin:
                                  const EdgeInsets.only(top: 100, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kcPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(90)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/landing_page',
                                      (Route<dynamic> route) => false);
                                },
                                child: const Text(
                                  "COMMANDER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
