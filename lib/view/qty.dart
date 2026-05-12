// ignore_for_file: must_be_immutable, avoid_print, unused_field, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tylunch/extension/date.dart';
import 'package:tylunch/extension/list.dart';
import 'package:tylunch/model/weekdays.dart';
import 'package:tylunch/model/weeklymenu.dart';
import 'package:tylunch/viewmodel/weekly_menu.dart';
import '../global/color.dart';
import '../global/container.dart';
import '../model/cartprod.dart';
import '../model/menu.dart';
import '../model/new_cart_model.dart';
import '../model/product.dart';
import '../services/api/order.dart';
import '../services/database.dart';
import '../viewmodel/cart.dart';

class QtyPage extends StatefulWidget {
  QtyPage({
    super.key,
    required this.fromGeorgettes,
    this.prod,
    required this.label,
    this.formulaQty = 0,
    this.georgettesQty = 0,
    this.fromFormula = false,
    this.hasFormula = false,
    this.cartId,
    this.cartProduct,
    this.date,
    this.day,
    this.menuId,
    this.prodStock,
    this.categoryId,
    this.categoryQty,
    this.individualQty = 0,
  });
  final String label;
  final bool fromFormula;
  final bool hasFormula;
  final bool fromGeorgettes;
  ProductModel? prod;
  int formulaQty;
  int? prodStock;
  CartProduct? cartProduct;
  int? cartId;
  String? date;
  int? day;
  int? menuId;
  int? categoryId;
  int? categoryQty;
  int individualQty;
  int georgettesQty;

  @override
  State<QtyPage> createState() => _QtyPageState();
}

class _QtyPageState extends State<QtyPage> {
  final WeeklyMenuViewModel _weeklyMenu = WeeklyMenuViewModel.instance;
  final DatabaseServices db = DatabaseServices.instance;
  final CartViewModel _cartViewModel = CartViewModel.instance;
  late final StreamSubscription<WeeklyMenuModel> _streamer;
  final OrderAPI order = OrderAPI();
  List<ProductModel> product = [];
  late List<WeekdaysModel> weekday;
  late List<MenuModel>? menu;
  int currentqty = 0;
  late int stock;

  // initStream() {
  //   // _streamer = _weeklyMenu.stream.listen((event) {
  //   //   weekday = List.from(event.menus as Iterable);
  //   //   menu = weekday
  //   //       .expand((element) =>
  //   //           element.menu!.where((element) => element.id == widget.menuId))
  //   //       .toList();
  //   //   product = menu![0]
  //   //       .details
  //   //       .categories
  //   //       .expand((e) => e.products
  //   //           .where((element) => element.categoryId == widget.categoryId))
  //   //       .toList();
  //   //   for (final ProductModel prod in product) {
  //   //     if (widget.cartProduct!.productId == prod.id) {
  //   //       stock = prod.stock;
  //   //       print("STOCKKKKKKK: ${prod.stock}");
  //   //     }
  //   //   }
  //   //   if (mounted) setState(() {});
  //   // });
  // }

  @override
  void initState() {
    // initStream();
    if (widget.fromGeorgettes == true) {
      print("FROM GEORGETTE");
      print("GEORGETTE QTY: ${widget.georgettesQty}");
    } else {
      print("FROM CART");
      currentqty =
          widget.formulaQty + int.parse(widget.individualQty.toString());
      print(
          "CURRENT QTY: ${widget.formulaQty} + ${int.parse(widget.individualQty.toString())} = $currentqty");
    }
    print("STOCK: ${widget.prodStock}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.fromGeorgettes == true ? 350 : 300,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${widget.label[0].toUpperCase()}${widget.label.substring(1)}",
            style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w600, color: kcPrimary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.fromGeorgettes == true
                  ? Row(
                      children: [
                        Text(
                          "${widget.prod!.price.toStringAsFixed(2)}€",
                          style: const TextStyle(
                            fontSize: 36,
                            color: kcPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 50),
                      ],
                    )
                  : Container(),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    if (widget.fromGeorgettes == true) {
                      print("FROM GEORGETTES");
                      if (widget.georgettesQty > 0) {
                        widget.georgettesQty--;
                        print(
                            "Georgettes CURRENT QTY: ${widget.georgettesQty}");
                      } else {
                        widget.georgettesQty;
                        print(
                            "Georgettes CURRENT QTY: ${widget.georgettesQty}");
                      }
                    } else {
                      print("FROM CART");
                      if (widget.fromFormula == true) {
                        print("FROM FORMULA");
                        if (widget.formulaQty > 0) {
                          widget.formulaQty--;
                          currentqty = widget.formulaQty + widget.individualQty;
                          print("CART FORMULA CURRENT QTY: $currentqty");
                        } else {
                          widget.formulaQty;
                          currentqty = widget.formulaQty + widget.individualQty;
                          print("CART FORMULA CURRENT QTY: $currentqty");
                        }
                      } else {
                        print("INDIVIDUAL");
                        if (widget.individualQty > 0) {
                          widget.individualQty--;
                          currentqty = widget.individualQty + widget.formulaQty;
                          print("CART INDI CURRENT QTY: $currentqty");
                        } else {
                          widget.individualQty;
                          currentqty = widget.individualQty + widget.formulaQty;
                          print("CART INDI CURRENT QTY: $currentqty");
                        }
                      }
                    }
                  });
                },
                icon: SvgPicture.asset("assets/icons/less.svg"),
              ),
              SizedBox(
                  width: widget.fromGeorgettes == true ? 70 : 120,
                  child: Text(
                      "${widget.fromGeorgettes == true ? widget.georgettesQty : widget.fromFormula == true ? widget.formulaQty : widget.individualQty}",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        color: kcPrimary,
                      ),
                      textAlign: TextAlign.center)),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    if (widget.fromGeorgettes == true) {
                      print("FROM GEORGETTES");
                      widget.georgettesQty++;
                      print("GEORGETTES CURRENT QTY: ${widget.georgettesQty}");
                    } else {
                      print("FROM CART");
                      widget.fromFormula == true
                          ? widget.formulaQty++
                          : widget.individualQty++;
                      currentqty = widget.formulaQty + widget.individualQty;
                      print("CART CURRENT QTY: $currentqty");
                    }
                  });
                },
                icon: SvgPicture.asset("assets/icons/add.svg"),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 60,
            width: 250,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kcPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              onPressed: () async {
                if (widget.fromGeorgettes == true) {
                  print("DIRI TIKANG SA CART");
                  if (widget.prod!.stock < widget.georgettesQty) {
                    print("OUT OF STOCK");
                    Fluttertoast.showToast(
                        msg:
                            "Plus disponible, stock disponible ${widget.prod!.stock}");
                  } else {
                    print(
                        "date: ${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.date.toString()))}, menuId: ${int.parse(widget.menuId.toString())}");
                    await order
                        .addtoCart(
                      date: DateFormat("yyyy-MM-dd")
                          .format(DateTime.parse(widget.date.toString())),
                      day: int.parse(widget.day.toString()),
                      menuId: int.parse(widget.menuId.toString()),
                      prodId: widget.prod!.id,
                      catId: int.parse(widget.categoryId.toString()),
                      orderQty: widget.georgettesQty,
                    )
                        .then((value) async {
                      if (value == true) {
                        print("ADD TO CART VALUE: $value");

                        print(" CURRRENT ${_cartViewModel.current}");
                        List<NewCartModel> val = _cartViewModel.current;
                        List<NewCartModel> current = val
                            .where((element) => element.date.isSameDate(
                                DateTime.parse(widget.date.toString())))
                            .toList();

                        if (current.isNotEmpty) {
                          final NewCartModel currentVal = current.first;
                          print("ADD SINGLE");
                          final CartProduct cartProd = CartProduct(
                            productId: widget.prod!.id,
                            quantity: widget.georgettesQty,
                            price: widget.prod!.price,
                            total: widget.georgettesQty * widget.prod!.price,
                            name: widget.prod!.dishName,
                            day: int.parse(widget.day.toString()),
                            menuId: int.parse(widget.menuId.toString()),
                            categoryId: int.parse(widget.categoryId.toString()),
                          );

                          if (currentVal.products.hasProduct(widget.prod!.id)) {
                            print("CART PRODUCT: $cartProd");

                            /// update
                            await db
                                .updateItem(
                              cartId: currentVal.id,
                              product: cartProd,
                            )
                                .whenComplete(() async {
                              await db.retrieve().then((value) {
                                if (value!.isNotEmpty) {
                                  // addToFormula(cartdata: value);
                                }
                              });
                              Navigator.of(context).pop();
                              if (mounted) setState(() {});
                            });
                            return;
                          }

                          await db
                              .addSingleItem(
                            cartId: currentVal.id,
                            product: cartProd,
                          )
                              .whenComplete(() async {
                            await db.retrieve().then((value) {
                              if (value!.isNotEmpty) {
                                // addToFormula(cartdata: value);
                              }
                            });
                            Navigator.of(context).pop();
                            if (mounted) setState(() {});
                          });
                        } else {
                          /// ADD ALL
                          final NewCartModel toAdd = NewCartModel(
                            id: DateTime.now().millisecondsSinceEpoch,
                            subTotal: widget.georgettesQty * widget.prod!.price,
                            date: DateTime.parse(widget.date.toString()),
                            clientId: loggedUser!.id,
                            products: [
                              CartProduct(
                                productId: widget.prod!.id,
                                quantity: widget.georgettesQty,
                                price: widget.prod!.price,
                                total:
                                    widget.georgettesQty * widget.prod!.price,
                                day: int.parse(widget.day.toString()),
                                menuId: int.parse(widget.menuId.toString()),
                                categoryId:
                                    int.parse(widget.categoryId.toString()),
                                name: widget.prod!.dishName,
                              ),
                            ],
                          );
                          print("ADD ALL $toAdd");
                          await db.addItem(toAdd).whenComplete(() async {
                            await db.retrieve().then((value) {
                              if (value!.isNotEmpty) {
                                // addToFormula(cartdata: value);
                              }
                            });

                            Navigator.of(context).pop();
                            if (mounted) setState(() {});
                          });
                        }
                      }
                    });
                  }
                } else {
                  print("TIKANG SA CART");
                  print("PRODUCCTTTT STOCK: ${widget.prodStock}");
                  if (widget.prodStock! < currentqty) {
                    print("CURRENT QTY: $currentqty");
                    Fluttertoast.showToast(msg: "quantité dépassée");
                    return;
                  } else if (widget.prodStock! < widget.formulaQty) {
                    print("OUT OF STOCK");
                    Fluttertoast.showToast(
                        msg:
                            "Plus disponible, stock disponible ${widget.prodStock!}");
                    return;
                  } else if (widget.prodStock! < widget.individualQty) {
                    print("OUT OF STOCK");
                    Fluttertoast.showToast(
                        msg:
                            "Plus disponible, stock disponible ${widget.prodStock!}");
                    return;
                  } else {
                    print("CURRRENT ${_cartViewModel.current}");

                    if (widget.fromFormula == true) {
                      print("sa formula ine tikang");
                      print("QTY: ${widget.formulaQty}");

                      if (widget.formulaQty == 0) {
                        print("ig delete an product na tua sa formula");
                        if (widget.formulaQty == 0 && widget.categoryQty == 0) {
                          print("delete product sa formula");
                          await db
                              .deleteProduct(
                                  prodId: int.parse(
                                      widget.cartProduct!.productId.toString()),
                                  cartId: int.parse(widget.cartId.toString()))
                              .then((value) async {
                            await db.retrieve();
                            Fluttertoast.showToast(msg: " élément supprimé ");
                            Navigator.of(context).pop();
                            if (mounted) setState(() {});
                          });
                        } else {
                          List<NewCartModel> val = _cartViewModel.current;
                          List<NewCartModel> current = val
                              .where((element) => element.date.isSameDate(
                                  DateTime.parse(widget.date.toString())))
                              .toList();
                          if (current.isNotEmpty) {
                            final NewCartModel currentVal = current.first;

                            final CartProduct cartProd = CartProduct(
                              productId: widget.cartProduct!.productId,
                              quantity: widget.formulaQty,
                              price: widget.cartProduct!.price,
                              total:
                                  widget.formulaQty * widget.cartProduct!.price,
                              name: widget.cartProduct!.name,
                              day: int.parse(widget.day.toString()),
                              menuId: int.parse(widget.menuId.toString()),
                              categoryId:
                                  int.parse(widget.categoryId.toString()),
                            );
                            if (currentVal.products
                                .hasProduct(widget.cartProduct!.productId)) {
                              await db
                                  .updateQty(
                                cartId: currentVal.id,
                                product: cartProd,
                                qty: widget.formulaQty + widget.individualQty,
                              )
                                  .then((value) async {
                                await db.retrieve();
                              });
                              Navigator.of(context).pop();
                              if (mounted) setState(() {});
                            }
                          }
                        }
                      } else if (widget.formulaQty != 0) {
                        print("dugangan an product na tua sa formula");
                        List<NewCartModel> val = _cartViewModel.current;
                        List<NewCartModel> current = val
                            .where((element) => element.date.isSameDate(
                                DateTime.parse(widget.date.toString())))
                            .toList();
                        if (current.isNotEmpty) {
                          final NewCartModel currentVal = current.first;

                          final CartProduct cartProd = CartProduct(
                            productId: widget.cartProduct!.productId,
                            quantity: widget.formulaQty,
                            price: widget.cartProduct!.price,
                            total:
                                widget.formulaQty * widget.cartProduct!.price,
                            name: widget.cartProduct!.name,
                            day: int.parse(widget.day.toString()),
                            menuId: int.parse(widget.menuId.toString()),
                            categoryId: int.parse(widget.categoryId.toString()),
                          );
                          if (currentVal.products
                              .hasProduct(widget.cartProduct!.productId)) {
                            await db
                                .updateQty(
                              cartId: currentVal.id,
                              product: cartProd,
                              qty: widget.formulaQty +
                                  // widget.individualQty +
                                  widget.categoryQty!,
                            )
                                .then((value) async {
                              await db.retrieve();
                            });
                            Navigator.of(context).pop();
                            if (mounted) setState(() {});
                          }
                        }
                      }
                    } else {
                      print("dili tikang sa formula");
                      print("QTY: ${widget.individualQty}");

                      if (widget.hasFormula == true) {
                        if (widget.individualQty != 0) {
                          print("dugangan an product na waray sa formula");
                          List<NewCartModel> val = _cartViewModel.current;
                          List<NewCartModel> current = val
                              .where((element) => element.date.isSameDate(
                                  DateTime.parse(widget.date.toString())))
                              .toList();
                          if (current.isNotEmpty) {
                            final NewCartModel currentVal = current.first;

                            final CartProduct cartProd = CartProduct(
                              productId: widget.cartProduct!.productId,
                              quantity: widget.individualQty,
                              price: widget.cartProduct!.price,
                              total: widget.individualQty *
                                  widget.cartProduct!.price,
                              name: widget.cartProduct!.name,
                              day: int.parse(widget.day.toString()),
                              menuId: int.parse(widget.menuId.toString()),
                              categoryId:
                                  int.parse(widget.categoryId.toString()),
                            );
                            if (currentVal.products
                                .hasProduct(widget.cartProduct!.productId)) {
                              await db
                                  .updateQty(
                                cartId: currentVal.id,
                                product: cartProd,
                                qty: widget.individualQty + widget.categoryQty!,
                              )
                                  .then((value) async {
                                await db.retrieve();
                              });
                              Navigator.of(context).pop();
                              if (mounted) setState(() {});
                            }
                          }
                        } else if (widget.individualQty == 0) {
                          print("ig delete an product na waray sa formula");
                          List<NewCartModel> val = _cartViewModel.current;
                          List<NewCartModel> current = val
                              .where((element) => element.date.isSameDate(
                                  DateTime.parse(widget.date.toString())))
                              .toList();
                          if (current.isNotEmpty) {
                            final NewCartModel currentVal = current.first;

                            final CartProduct cartProd = CartProduct(
                              productId: widget.cartProduct!.productId,
                              quantity: widget.individualQty,
                              price: widget.cartProduct!.price,
                              total: widget.individualQty *
                                  widget.cartProduct!.price,
                              name: widget.cartProduct!.name,
                              day: int.parse(widget.day.toString()),
                              menuId: int.parse(widget.menuId.toString()),
                              categoryId:
                                  int.parse(widget.categoryId.toString()),
                            );
                            if (currentVal.products
                                .hasProduct(widget.cartProduct!.productId)) {
                              await db.updateQty(
                                  cartId: currentVal.id,
                                  product: cartProd,
                                  qty: widget.categoryQty!);
                              await db.retrieve();
                              Navigator.of(context).pop();
                              if (mounted) setState(() {});
                            }
                          }
                        }
                      } else {
                        print(" WITHOUT FORMULA");
                        if (widget.individualQty == 0) {
                          print("DELETE PRODUCT WITHOUT FORMULA");
                          await db.deleteProduct(
                              prodId: int.parse(
                                  widget.cartProduct!.productId.toString()),
                              cartId: int.parse(widget.cartId.toString()));
                          Navigator.of(context).pop();
                          await db.retrieve();
                          Fluttertoast.showToast(msg: " élément supprimé ");
                          if (mounted) setState(() {});
                        } else {
                          print("ADD/SUBTRACT THE PRODUCT WITHOUT FORMULA");
                          List<NewCartModel> val = _cartViewModel.current;
                          List<NewCartModel> current = val
                              .where((element) => element.date.isSameDate(
                                  DateTime.parse(widget.date.toString())))
                              .toList();
                          if (current.isNotEmpty) {
                            final NewCartModel currentVal = current.first;

                            final CartProduct cartProd = CartProduct(
                              productId: widget.cartProduct!.productId,
                              quantity: widget.individualQty,
                              price: widget.cartProduct!.price,
                              total: widget.individualQty *
                                  widget.cartProduct!.price,
                              name: widget.cartProduct!.name,
                              day: int.parse(widget.day.toString()),
                              menuId: int.parse(widget.menuId.toString()),
                              categoryId:
                                  int.parse(widget.categoryId.toString()),
                            );

                            if (currentVal.products
                                .hasProduct(widget.cartProduct!.productId)) {
                              if (widget.categoryQty == 0) {
                                await db.updateQty(
                                  cartId: currentVal.id,
                                  product: cartProd,
                                  qty: widget.individualQty,
                                );
                                Navigator.of(context).pop();
                                await db.retrieve();
                                if (mounted) setState(() {});
                              }
                            }
                          }
                        }
                      }
                    }
                    return;
                  }
                }
              },
              child: Text(
                widget.fromGeorgettes == false
                    ? "CONFIRMER"
                    : "AJOUTER\nAU PANIER",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          widget.fromGeorgettes == true
              ? SizedBox(
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
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
