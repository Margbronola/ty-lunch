// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tylunch/extension/date.dart';
import 'package:tylunch/extension/list.dart';
import 'package:tylunch/model/product.dart';

import '../global/color.dart';
import '../global/container.dart';
import '../model/cartprod.dart';
import '../model/menu_details.dart';
import '../model/new_cart_model.dart';
import '../services/database.dart';
import '../viewmodel/cart.dart';

class DrinkPage extends StatefulWidget {
  const DrinkPage({
    super.key,
    required this.data,
    required this.sched,
    required this.day,
    required this.menuId,
    required this.categoryId,
  });
  final List<CategorizedData> data;
  final String sched;
  final int day;
  final int menuId;
  final int categoryId;

  @override
  State<DrinkPage> createState() => _DrinkPageState();
}

class _DrinkPageState extends State<DrinkPage> {
  final DatabaseServices dbhandler = DatabaseServices.instance;
  late List<CartProduct> cartProd = [];
  final CartViewModel _cartViewModel = CartViewModel.instance;
  late List<int> pcs = [];
  late final double subtotal = getTotal();

  @override
  void initState() {
    for (final CategorizedData element in widget.data) {
      for (final ProductModel prod in element.products) {
        pcs.add(int.parse("0"));
      }
    }
    drinks();
    super.initState();
  }

  double getTotal() {
    double amount = 0.0;
    for (final CartProduct cart in cartProd) {
      amount += cart.total;
    }
    return amount;
  }

  void drinks() {
    final List<ProductModel> drinks =
        widget.data.expand((element) => element.products).toList();

    for (final ProductModel prod in drinks) {
      cartProd.add(
        CartProduct(
          productId: prod.id,
          quantity: 0,
          price: prod.price,
          total: 0.00,
          day: widget.day,
          menuId: widget.menuId,
          name: prod.dishName,
          categoryId: widget.categoryId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        minChildSize: .5,
        initialChildSize: .8,
        maxChildSize: .8,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Boissons",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: kcPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (c, i) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.data[0].products[i].dishName[0].toUpperCase()}${widget.data[0].products[i].dishName.substring(1)}",
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.w600,
                                          color: kcPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${widget.data[0].products[i].price}€",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: kcPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            if (pcs[i] > 0) {
                                              setState(() {
                                                pcs[i]--;
                                                final cartProdInd = cartProd
                                                    .indexWhere((element) =>
                                                        element.productId ==
                                                        widget.data[0]
                                                            .products[i].id);
                                                final updateQty = CartProduct(
                                                  productId: widget
                                                      .data[0].products[i].id,
                                                  quantity: pcs[i],
                                                  price: widget.data[0]
                                                      .products[i].price,
                                                  total: pcs[i] *
                                                      widget.data[0].products[i]
                                                          .price,
                                                  name: widget.data[0]
                                                      .products[i].dishName,
                                                  day: widget.day,
                                                  menuId: widget.menuId,
                                                  categoryId: widget.categoryId,
                                                );

                                                cartProd[cartProdInd] =
                                                    updateQty;
                                              });
                                            }
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/icons/less.svg",
                                          width: 35,
                                        ),
                                      ),
                                      Center(
                                        child: SizedBox(
                                            width: 50,
                                            child: Text(
                                              "${pcs[i]}",
                                              style: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.w600,
                                                color: kcPrimary,
                                              ),
                                              textAlign: TextAlign.center,
                                            )
                                            //     TextFormField(
                                            //   controller: qtyList[0][i],
                                            //   keyboardType: TextInputType.number,
                                            //   textAlign: TextAlign.center,
                                            //   style: const TextStyle(
                                            //     fontSize: 35,
                                            //     color: kcPrimary,
                                            //     fontWeight: FontWeight.w600,
                                            //   ),
                                            // ),
                                            ),
                                      ),
                                      IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            pcs[i]++;

                                            final cartProdInd =
                                                cartProd.indexWhere((element) =>
                                                    element.productId ==
                                                    widget.data[0].products[i]
                                                        .id);
                                            final updateQty = CartProduct(
                                              productId:
                                                  widget.data[0].products[i].id,
                                              quantity: pcs[i],
                                              price: widget
                                                  .data[0].products[i].price,
                                              total: pcs[i] *
                                                  widget.data[0].products[i]
                                                      .price,
                                              name: widget
                                                  .data[0].products[i].dishName,
                                              day: widget.day,
                                              menuId: widget.menuId,
                                              categoryId: widget.categoryId,
                                            );

                                            cartProd[cartProdInd] = updateQty;
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/icons/add.svg",
                                          width: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(height: 20)
                          ],
                        );
                      },
                      separatorBuilder: (c, ii) => const SizedBox(height: 15),
                      itemCount: widget.data[0].products.length,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      height: 60,
                      width: size.width * .6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: kcPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(90),
                          ),
                        ),
                        onPressed: () async {
                          List<NewCartModel> val = _cartViewModel.current;
                          List<NewCartModel> current = val
                              .where((element) => element.date
                                  .isSameDate(DateTime.parse(widget.sched)))
                              .toList();
                          print("CURRENT: $current}");

                          final List<CartProduct> cartProduct = cartProd
                              .where((element) => element.quantity != 0)
                              .toList();

                          if (current.isNotEmpty) {
                            final NewCartModel currentVal = current.first;
                            print("ADD SINGLE");

                            for (final CartProduct cart in cartProduct) {
                              if (currentVal.products
                                  .hasProduct(cart.productId)) {
                                /// update
                                await dbhandler
                                    .updateItem(
                                  cartId: currentVal.id,
                                  product: cart,
                                )
                                    .whenComplete(() async {
                                  await dbhandler.retrieve();
                                  if (mounted) setState(() {});
                                });
                                return;
                              }
                              await dbhandler
                                  .addSingleItem(
                                cartId: currentVal.id,
                                product: cart,
                              )
                                  .whenComplete(() async {
                                await dbhandler.retrieve();
                                if (mounted) setState(() {});
                              });
                            }
                          } else {
                            final List<CartProduct> cartProduct = cartProd
                                .where((element) => element.quantity != 0)
                                .toList();

                            print("CART PRODUCT: $cartProduct");

                            /// ADD ALL
                            final NewCartModel toAdd = NewCartModel(
                                id: DateTime.now().millisecondsSinceEpoch,
                                subTotal: subtotal,
                                date: DateTime.parse(widget.sched),
                                // paymentMethod: "credit",
                                clientId: loggedUser!.id,
                                products: cartProduct);
                            print("ADD ALL $toAdd");
                            await dbhandler
                                .addItem(toAdd)
                                .whenComplete(() async {
                              await dbhandler.retrieve();
                              if (mounted) setState(() {});
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "AJOUTER\nAU PANIER",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 60,
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
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
