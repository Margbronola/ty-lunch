// ignore_for_file: avoid_print, must_be_immutable, use_build_context_synchronously

import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tylunch/model/category.dart';

import '../global/color.dart';
import '../global/network.dart';
import '../global/widget.dart';
import '../model/cartprod.dart';
import '../services/api/order.dart';
import '../viewmodel/cart.dart';
import '../global/container.dart';
import '../services/database.dart';
import '../model/new_cart_model.dart';
import 'package:flutter/material.dart';
import 'package:tylunch/model/product.dart';
import 'package:tylunch/extension/date.dart';
import 'package:tylunch/extension/list.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MenuDetailPage extends StatefulWidget {
  ProductModel prod;
  String date;
  final int day;
  final int menuId;
  final CategoryModel categoryId;
  MenuDetailPage({
    super.key,
    required this.prod,
    required this.date,
    required this.day,
    required this.menuId,
    required this.categoryId,
  });

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final DatabaseServices dbhandler = DatabaseServices.instance;
  final CartViewModel _cartViewModel = CartViewModel.instance;
  final OrderAPI order = OrderAPI();
  final CustomWidget cw = CustomWidget();
  List<NewCartModel> cart = [];
  bool expanded = false;
  int qty = 1;

  void _addQty() {
    setState(() {
      qty++;
    });
  }

  void _minusQty() {
    setState(() {
      if (qty > 1) {
        qty--;
      } else {
        qty;
      }
    });
  }

  @override
  void initState() {
    dbhandler.retrieve();
    _cartViewModel.stream.listen((event) {
      populateCart();
    });
    super.initState();
  }

  void populateCart() async {
    try {
      cart = List.from(_cartViewModel.current);
      print("CART LENGHT adfsahgdfjvgashdfsaghd: $cart");
    } catch (e) {
      cart.clear();
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        minChildSize: .5,
        initialChildSize: .99,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 10),
                  Text(
                    "${widget.prod.dishName[0].toUpperCase()}${widget.prod.dishName.substring(1)}",
                    style: const TextStyle(
                      fontSize: 28,
                      color: kcPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 352,
                    height: 352,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          cw.shimmerLoading(kcPrimary, 352),
                          if (widget.prod.photo.isNotEmpty) ...{
                            Image.network(
                              "${Network.url}/storage/${widget.prod.photo[0].location}",
                              fit: BoxFit.cover,
                              width: 352,
                              height: 352,
                              errorBuilder: (_, o, s) => Image.asset(
                                "assets/images/placeholder.jpeg",
                                fit: BoxFit.cover,
                                width: 352,
                                height: 352,
                              ),
                            )
                          } else ...{
                            Image.asset(
                              "assets/images/placeholder.jpeg",
                              fit: BoxFit.cover,
                            )
                          },
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.prod.ingredients == null
                        ? ""
                        : "${widget.prod.ingredients}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.prod.allergen!.isEmpty
                        ? ""
                        : "*${widget.prod.allergen!.map((e) => e.name).join(', ')}",
                    //  Allergènes :
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: widget.prod.allergen!.isEmpty ? 0 : 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.categoryId.price.toStringAsFixed(2)}€",
                        style: const TextStyle(
                          fontSize: 36,
                          color: kcPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _minusQty();
                            },
                            icon: SvgPicture.asset("assets/icons/less.svg"),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                              width: 50,
                              child: Text(
                                "$qty",
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                  color: kcPrimary,
                                ),
                                textAlign: TextAlign.center,
                              )
                              // TextFormField(
                              //   controller: qty,
                              //   decoration: const InputDecoration(
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //           width: 1, color: Colors.black),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //           width: 1, color: Colors.black),
                              //     ),
                              //   ),
                              // style: const TextStyle(
                              //   fontSize: 36,
                              //   fontWeight: FontWeight.w600,
                              //   color: kcPrimary,
                              // ),
                              // textAlign: TextAlign.center,
                              // ),
                              ),
                          const SizedBox(width: 5),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _addQty();
                            },
                            icon: SvgPicture.asset("assets/icons/add.svg"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          width: size.width * .6,
                          child: ElevatedButton(
                            onPressed: () async {
                              for (final NewCartModel c in cart) {
                                print("${c.date} - ${widget.date}");
                                if (c.date == DateTime.parse(widget.date)) {
                                  for (final CartProduct cp in c.products) {
                                    if (widget.prod.id == cp.productId) {
                                      print(
                                          "CART PRODUCTTTTT: ${cp.productId} - ${cp.name}");
                                      print(
                                          "PRODUCTTTTT: ${widget.prod.id} - ${widget.prod.dishName}");
                                      int remainingStocks =
                                          widget.prod.stock - cp.quantity - qty;
                                      if (remainingStocks <= 0) {
                                        print(
                                            "REMAINING STOCKS: $remainingStocks");
                                        Fluttertoast.showToast(
                                            msg: "quantité dépassée");
                                        return;
                                      }
                                    }
                                  }
                                }
                              }
                              if (widget.prod.stock < qty) {
                                print("OUT OF STOCK");
                                Fluttertoast.showToast(
                                    msg:
                                        "Plus disponible, stock disponible ${widget.prod.stock}");
                              } else {
                                print(
                                    "${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.date))}, ${widget.day}, ${widget.menuId}, ${widget.prod.id}, ${widget.categoryId.id} ,$qty");
                                await order
                                    .addtoCart(
                                  date: DateFormat("yyyy-MM-dd")
                                      .format(DateTime.parse(widget.date)),
                                  day: widget.day,
                                  menuId: widget.menuId,
                                  prodId: widget.prod.id,
                                  catId: widget.categoryId.id,
                                  orderQty: qty,
                                )
                                    .then((value) async {
                                  if (value == true) {
                                    print("ADD TO CART VALUE: $value");

                                    print(
                                        " CURRRENT ${_cartViewModel.current}");
                                    List<NewCartModel> val =
                                        _cartViewModel.current;
                                    List<NewCartModel> current = val
                                        .where((element) => element.date
                                            .isSameDate(
                                                DateTime.parse(widget.date)))
                                        .toList();

                                    if (current.isNotEmpty) {
                                      final NewCartModel currentVal =
                                          current.first;
                                      print("ADD SINGLE");
                                      final CartProduct cartProd = CartProduct(
                                        productId: widget.prod.id,
                                        quantity: qty,
                                        price: widget.prod.price,
                                        total: qty * widget.prod.price,
                                        name: widget.prod.dishName,
                                        day: widget.day,
                                        menuId: widget.menuId,
                                        categoryId: widget.categoryId.id,
                                      );

                                      if (currentVal.products
                                          .hasProduct(widget.prod.id)) {
                                        print("CART PRODUCT: $cartProd");

                                        /// update
                                        await dbhandler
                                            .updateItem(
                                          cartId: currentVal.id,
                                          product: cartProd,
                                        )
                                            .whenComplete(() async {
                                          await dbhandler
                                              .retrieve()
                                              .then((value) {
                                            if (value!.isNotEmpty) {
                                              // addToFormula(cartdata: value);
                                            }
                                          });
                                          Navigator.of(context).pop();
                                          if (mounted) setState(() {});
                                        });
                                        return;
                                      }

                                      await dbhandler
                                          .addSingleItem(
                                        cartId: currentVal.id,
                                        product: cartProd,
                                      )
                                          .whenComplete(() async {
                                        await dbhandler
                                            .retrieve()
                                            .then((value) {
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
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        subTotal: qty * widget.prod.price,
                                        date: DateTime.parse(widget.date),
                                        // paymentMethod: "credit",
                                        clientId: loggedUser!.id,
                                        products: [
                                          CartProduct(
                                            productId: widget.prod.id,
                                            quantity: qty,
                                            price: widget.prod.price,
                                            total: qty * widget.prod.price,
                                            day: widget.day,
                                            menuId: widget.menuId,
                                            categoryId: widget.categoryId.id,
                                            name: widget.prod.dishName,
                                          ),
                                        ],
                                      );
                                      print("ADD ALL $toAdd");
                                      await dbhandler
                                          .addItem(toAdd)
                                          .whenComplete(() async {
                                        await dbhandler
                                            .retrieve()
                                            .then((value) {
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kcPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90),
                              ),
                            ),
                            child: const Text(
                              "AJOUTER\nAU PANIER",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}