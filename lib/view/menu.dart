// ignore_for_file: must_be_immutable, avoid_print, unused_local_variable, deprecated_member_use

import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:tylunch/global/cartlength.dart';
import 'package:tylunch/model/category.dart';
import 'package:tylunch/model/menu_details.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/view/category.dart';
import 'package:tylunch/view/landing.dart';
import 'package:tylunch/services/database.dart';
import 'package:tylunch/view/qty.dart';
import 'package:tylunch/viewmodel/cart.dart';
import '../global/network.dart';
import '../model/formula.dart';
import '../model/menu.dart';
import '../model/product.dart';
import '../model/weekdays.dart';
import '../viewmodel/category.dart';
import '../viewmodel/formula.dart';
import 'drinks.dart';
import 'menudetail.dart';

class Data {
  final int id;
  final Widget image;
  Data({required this.image, required this.id});
}

class MenuPage extends StatefulWidget {
  DateTime date;
  final WeekdaysModel menu;
  final ValueChanged<int>? onPagePressed;
  MenuPage(
      {super.key, required this.menu, required this.date, this.onPagePressed});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static final FormulaViewModel _viewModel = FormulaViewModel.instance;
  static final CategoryViewModel _categoryVM = CategoryViewModel.instance;
  final DatabaseServices dbhandler = DatabaseServices.instance;
  final CartViewModel _cartViewModel = CartViewModel.instance;
  final CustomWidget cw = CustomWidget();
  List<NewCartModel> cart = [];
  bool isloading = false;
  int selectedIndex = 0;
  late int cartLength;
  bool ontap = false;
  late double total;

  getTotalAmount(double price, int qty) {
    return total = price * qty;
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      print("SA MENU PAGE DAPAT INE");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(ind: 0)),
          (Route<dynamic> route) => false);
    } else if (index == 1) {
      print("SA CART PAGE DAPAT INE");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(ind: 1)),
          (Route<dynamic> route) => false);
    } else if (index == 2) {
      print("SA CART PAGE DAPAT INE");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(ind: 2)),
          (Route<dynamic> route) => false);
    } else if (index == 3) {
      print("SA CART PAGE DAPAT INE");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LandingPage(ind: 3)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    dbhandler.retrieve();
    print("MENU PAGE DATA: ${widget.menu}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String weekday = DateFormat("EEEE", 'fr_FR').format(widget.date);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/images/circ 5.svg",
                            color: secondaryColor,
                            width: 350,
                          ),
                          Positioned(
                            top: 82,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: SvgPicture.asset(
                                "assets/icons/chevron-left.svg",
                                width: 25,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 10,
                            child: Column(
                              children: [
                                CustomWidget().bodytext(
                                  label:
                                      "${weekday[0].toUpperCase()}${weekday.substring(1)}",
                                  color: kcPrimary,
                                  size: 40,
                                  weight: FontWeight.w600,
                                ),
                                Text(
                                  DateFormat("dd MMMM", 'fr_FR')
                                      .format(widget.date),
                                  style: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Vector.svg",
                                color: kcPrimary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: RichText(
                                text: const TextSpan(
                                    text: "PENSEZ ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'CraftRounded',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "À \nCOMMANDER LA VEILLE",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: kcPrimary,
                                        ),
                                      )
                                    ]),
                              )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder<List<CategoryModel>>(
                                        stream: _categoryVM.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              !snapshot.hasError) {
                                            final List<CategoryModel> result =
                                                snapshot.data!;
                                                print("CATEGORY DATA: $result");

                                            final Iterable<CategoryModel>
                                                catData = result.where(
                                                    (element) => element.name
                                                        .contains("Sur") || element.name
                                                        .contains("sur"));
                                        return Row(
                                          children: [
                                            const Text(
                                              "Sur le pouce :",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: kcPrimary,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${catData.first.price.toStringAsFixed(2)}€",
                                              // " 9.00 €",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: kcPrimary,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Container();
                                        }
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Nos formules :",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: kcPrimary,
                                      ),
                                    ),
                                    StreamBuilder<List<FormulaModel>>(
                                      stream: _viewModel.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            !snapshot.hasError) {
                                          if (snapshot.data!.isNotEmpty) {
                                            return ListView.builder(
                                              padding: const EdgeInsets.only(
                                                  top: 5, right: 15),
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (c, i) {
                                                return Row(
                                                  children: [
                                                    Text(
                                                      "${snapshot.data![i].name} :",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: kcPrimary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      " ${snapshot.data![i].price.toStringAsFixed(2)} €",
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: kcPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                        return Container();
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Les tarifs affichés ci-dessous sont unitaires. Selon nos menus, la meilleure proposition tarifaire est calculée dans votre panier.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: kcPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Image.asset(
                                  "assets/images/Ty-Lunch_Livraison.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (C, i) {
                        final List<MenuModel>? menus = widget.menu.menu;

                        final List<CategorizedData> surLePounce = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Sur le pouce") ||
                                element.name.contains("sur le pouce"))
                            .toList();

                        final List<CategorizedData> drinks = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Boissons") ||
                                element.name.contains("boissons") ||
                                element.name.contains("Boisson") ||
                                element.name.contains("boisson"))
                            .toList();
                        final List<CategorizedData> georgettes = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Georgettes") ||
                                element.name.contains("georgettes") ||
                                element.name.contains("Georgette") ||
                                element.name.contains("georgette"))
                            .toList();
                        final List<CategorizedData> pain = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Pains") ||
                                element.name.contains("pains") ||
                                element.name.contains("Pain") ||
                                element.name.contains("pain"))
                            .toList();
                        final List<CategorizedData> eau = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Eaus") ||
                                element.name.contains("eaus") ||
                                element.name.contains("eau") ||
                                element.name.contains("Eau"))
                            .toList();
                        final List<CategorizedData> dessert = widget
                            .menu.menu![i].details.categories
                            .where((element) =>
                                element.name.contains("Dessert") ||
                                element.name.contains("dessert"))
                            .toList();

                        final List<ProductModel> prod = dessert
                            .expand((element) => element.products)
                            .toList();

                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            widget.menu.menu!.length == 1
                                ? Container(height: 0)
                                : Center(
                                    child: Text(
                                      "MENU ${i + 1}",
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: kcPrimary,
                                      ),
                                    ),
                                  ),
                            surLePounce.isEmpty
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: StreamBuilder<List<CategoryModel>>(
                                        stream: _categoryVM.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              !snapshot.hasError) {
                                            final List<CategoryModel> result =
                                                snapshot.data!;

                                            final Iterable<CategoryModel>
                                                catData = result.where(
                                                    (element) => element.name
                                                        .contains(surLePounce
                                                            .first.name));

                                            List<ProductModel> prod =
                                                surLePounce
                                                    .expand((element) =>
                                                        element.products)
                                                    .toList();
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * .17,
                                                      child: SvgPicture.asset(
                                                        "assets/images/sur-le-pouce-logo.svg",
                                                        width: 90,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Expanded(
                                                      child: Text(
                                                        "Sur le pouce",
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: kcPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * .3,
                                                      child: Text(
                                                        "${catData.first.price.toStringAsFixed(2)}€",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: kcPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 285,
                                                  width: double.infinity,
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (context, x) {
                                                      return SizedBox(
                                                        height: 250,
                                                        width: 234,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    size.height,
                                                              ),
                                                              context: context,
                                                              builder: (_) =>
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            0,
                                                                        sigmaY:
                                                                            0),
                                                                child:
                                                                    MenuDetailPage(
                                                                  prod: prod[x],
                                                                  date: widget
                                                                      .date
                                                                      .toString(),
                                                                  menuId: widget
                                                                      .menu
                                                                      .menu![i]
                                                                      .menuID,
                                                                  day: int.parse(
                                                                      widget
                                                                          .menu
                                                                          .key
                                                                          .toString()),
                                                                  categoryId:
                                                                      catData
                                                                          .first,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "${prod[x].dishName[0].toUpperCase()}${prod[x].dishName.substring(1)}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              kcPrimary,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            20),
                                                                    prod[x].vege ==
                                                                            1
                                                                        ? SvgPicture.asset(
                                                                            "assets/icons/vege.svg")
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                child: Stack(
                                                                  children: [
                                                                    cw.shimmerLoading(
                                                                        kcPrimary,
                                                                        234),
                                                                    Stack(
                                                                      children: [
                                                                        if (prod[x]
                                                                            .photo
                                                                            .isNotEmpty) ...{
                                                                          Image
                                                                              .network(
                                                                            "${Network.url}/storage/${prod[x].photo[0].location}",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                234,
                                                                            width:
                                                                                234,
                                                                            errorBuilder: (_, o, s) =>
                                                                                Image.asset(
                                                                              "assets/images/placeholder.jpeg",
                                                                              fit: BoxFit.cover,
                                                                              width: 234,
                                                                              height: 234,
                                                                            ),
                                                                          )
                                                                        } else ...{
                                                                          Image
                                                                              .asset(
                                                                            "assets/images/placeholder.jpeg",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                234,
                                                                            height:
                                                                                234,
                                                                          )
                                                                        },
                                                                        if (prod[x].stock ==
                                                                            0) ...{
                                                                          Positioned
                                                                              .fill(
                                                                            child:
                                                                                Container(
                                                                              color: Colors.white.withOpacity(.6),
                                                                              alignment: Alignment.center,
                                                                              child: SvgPicture.asset(
                                                                                "assets/icons/Frame 2669.svg",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        }
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                                width: 20),
                                                    itemCount: prod.length,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return const SizedBox();
                                        }),
                                  ),
                            const SizedBox(height: 20),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget
                                    .menu.menu![i].details.categories.length,
                                itemBuilder: (c, x) {
                                  return CategoryPage(
                                    category: widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("Boisson") ||
                                            widget.menu.menu![i].details.categories[x].name
                                                .contains("boisson") ||
                                            widget.menu.menu![i].details.categories[x].name
                                                .contains("Sur le pouce") ||
                                            widget.menu.menu![i].details.categories[x].name
                                                .contains("sur le pouce") ||
                                            widget.menu.menu![i].details.categories[x].name
                                                .contains("Georgettes") ||
                                            widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("georgettes") ||
                                            widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("Georgette") ||
                                            widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("georgette") ||
                                            widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("Dessert") ||
                                            widget.menu.menu![i].details
                                                .categories[x].name
                                                .contains("dessert") ||
                                            widget.menu.menu![i].details.categories[x].name.contains("Pain") ||
                                            widget.menu.menu![i].details.categories[x].name.contains("pain") ||
                                            widget.menu.menu![i].details.categories[x].name.contains("Eau") ||
                                            widget.menu.menu![i].details.categories[x].name.contains("eau")
                                        ? null
                                        : widget.menu.menu![i].details.categories[x],
                                    date: widget.date.toString(),
                                    menuId: widget.menu.menu![i].menuID,
                                    day: int.parse(widget.menu.key.toString()),
                                  );
                                }),
                            dessert.isEmpty
                                ? Container(height: 0)
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: StreamBuilder<List<CategoryModel>>(
                                        stream: _categoryVM.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              !snapshot.hasError) {
                                            final List<CategoryModel> result =
                                                snapshot.data!;

                                            final Iterable<CategoryModel>
                                                catData =
                                                result.where((element) =>
                                                    element.name.contains(
                                                        dessert.first.name));
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: size.width * .17,
                                                      child: SvgPicture.asset(
                                                        "assets/images/dessert-logo.svg",
                                                        width: 90,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      // width: size.width * .4,
                                                      child: Text(
                                                        "${catData.first.name[0].toUpperCase()}${catData.first.name.substring(1)}",
                                                        style: const TextStyle(
                                                          fontSize: 27,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: kcPrimary,
                                                        ),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * .3,
                                                      child: Text(
                                                        "${catData.first.price.toStringAsFixed(2)}€",
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: kcPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                  height: 280,
                                                  width: double.infinity,
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder: (context, x) {
                                                      return SizedBox(
                                                        height: 255,
                                                        width: 234,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight:
                                                                    size.height,
                                                              ),
                                                              context: context,
                                                              builder: (_) =>
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            0,
                                                                        sigmaY:
                                                                            0),
                                                                child:
                                                                    MenuDetailPage(
                                                                  prod: prod[x],
                                                                  date: widget
                                                                      .date
                                                                      .toString(),
                                                                  menuId: widget
                                                                      .menu
                                                                      .menu![i]
                                                                      .menuID,
                                                                  day: int.parse(
                                                                      widget
                                                                          .menu
                                                                          .key
                                                                          .toString()),
                                                                  categoryId:
                                                                      catData
                                                                          .first,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${prod[x].dishName[0].toUpperCase()}${prod[x].dishName.substring(1)}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color:
                                                                            kcPrimary,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          20),
                                                                  prod[x].vege ==
                                                                          1
                                                                      ? SvgPicture
                                                                          .asset(
                                                                              "assets/icons/vege.svg")
                                                                      : Container(),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                width: 234,
                                                                height: 234,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  child: Stack(
                                                                    children: [
                                                                      cw.shimmerLoading(
                                                                        kcPrimary,
                                                                        234,
                                                                      ),
                                                                      Stack(
                                                                        children: [
                                                                          if (prod[x]
                                                                              .photo
                                                                              .isNotEmpty) ...{
                                                                            Image.network(
                                                                              "${Network.url}/storage/${prod[x].photo[0].location}",
                                                                              fit: BoxFit.cover,
                                                                              width: 234,
                                                                              height: 234,
                                                                              errorBuilder: (_, o, s) => Image.asset(
                                                                                "assets/images/placeholder.jpeg",
                                                                                fit: BoxFit.cover,
                                                                                width: 234,
                                                                                height: 234,
                                                                              ),
                                                                            )
                                                                          } else ...{
                                                                            Image.asset(
                                                                              "assets/images/placeholder.jpeg",
                                                                              fit: BoxFit.cover,
                                                                              width: 234,
                                                                              height: 234,
                                                                            )
                                                                          },
                                                                          if (prod[x].stock ==
                                                                              0) ...{
                                                                            Positioned.fill(
                                                                              child: Container(
                                                                                color: Colors.white.withOpacity(.6),
                                                                                alignment: Alignment.center,
                                                                                child: SvgPicture.asset(
                                                                                  "assets/icons/Frame 2669.svg",
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          }
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                                width: 20),
                                                    itemCount: prod.length,
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                          return Container();
                                        }),
                                  ),
                            georgettes.isEmpty && drinks.isEmpty
                                //  &&
                                // pain.isEmpty &&
                                // eau.isEmpty
                                ? const SizedBox()
                                : Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/supplement.png",
                                              width: size.width * .14,
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Les petits plus",
                                              style: TextStyle(
                                                  fontSize: 27,
                                                  fontWeight: FontWeight.w800,
                                                  color: kcPrimary),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 270,
                                          width: size.width,
                                          child: StreamBuilder<
                                              List<CategoryModel>>(
                                            stream: _categoryVM.stream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData &&
                                                  !snapshot.hasError) {
                                                final List<CategoryModel>
                                                    result = snapshot.data!;

                                                final Iterable<
                                                        CategoryModel> drinkData =
                                                    result.where((element) =>
                                                        element.name.contains(
                                                            "Boissons") ||
                                                        element.name.contains(
                                                            "boissons") ||
                                                        element.name.contains(
                                                            "Boisson") ||
                                                        element.name.contains(
                                                            "boisson"));

                                                final Iterable<
                                                        CategoryModel>
                                                    georgettesData =
                                                    result.where((element) =>
                                                        element.name.contains(
                                                            "Georgettes") ||
                                                        element.name.contains(
                                                            "georgettes") ||
                                                        element.name.contains(
                                                            "Georgette") ||
                                                        element.name.contains(
                                                            "georgette"));

                                                final Iterable<CategoryModel>
                                                    painData =
                                                    result.where((element) =>
                                                        element.name
                                                            .contains("Pain") ||
                                                        element.name
                                                            .contains("pain"));

                                                final Iterable<CategoryModel>
                                                    eauData =
                                                    result.where((element) =>
                                                        element.name
                                                            .contains("Eau") ||
                                                        element.name
                                                            .contains("eau"));

                                                return ListView(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: [
                                                    // pain.isEmpty
                                                    //     ? const SizedBox()
                                                    //     : GestureDetector(
                                                    //         onTap: () {
                                                    //           showModalBottomSheet(
                                                    //             isScrollControlled:
                                                    //                 true,
                                                    //             backgroundColor:
                                                    //                 Colors
                                                    //                     .transparent,
                                                    //             constraints:
                                                    //                 BoxConstraints(
                                                    //               maxHeight: size
                                                    //                   .height,
                                                    //             ),
                                                    //             context:
                                                    //                 context,
                                                    //             builder: (_) =>
                                                    //                 BackdropFilter(
                                                    //               filter: ImageFilter
                                                    //                   .blur(
                                                    //                       sigmaX:
                                                    //                           0,
                                                    //                       sigmaY:
                                                    //                           0),
                                                    //               child:
                                                    //                   QtyPage(
                                                    //                 fromGeorgettes:
                                                    //                     true,
                                                    //                 label:
                                                    //                     "Quantité",
                                                    //                 georgettesQty:
                                                    //                     1,
                                                    //                 prod: pain[
                                                    //                         0]
                                                    //                     .products[0],
                                                    //                 date: widget
                                                    //                     .date
                                                    //                     .toString(),
                                                    //                 menuId: widget
                                                    //                     .menu
                                                    //                     .menu![
                                                    //                         0]
                                                    //                     .menuID,
                                                    //                 day: int.parse(
                                                    //                     widget
                                                    //                         .menu
                                                    //                         .key
                                                    //                         .toString()),
                                                    //                 categoryId:
                                                    //                     painData
                                                    //                         .first
                                                    //                         .id,
                                                    //               ),
                                                    //             ),
                                                    //           );
                                                    //         },
                                                    //         child: SizedBox(
                                                    //           width: 200,
                                                    //           child: Column(
                                                    //             crossAxisAlignment:
                                                    //                 CrossAxisAlignment
                                                    //                     .start,
                                                    //             children: [
                                                    //               Text(
                                                    //                 pain[0]
                                                    //                     .name,
                                                    //                 style:
                                                    //                     const TextStyle(
                                                    //                   fontSize:
                                                    //                       16,
                                                    //                   color:
                                                    //                       kcPrimary,
                                                    //                   fontWeight:
                                                    //                       FontWeight
                                                    //                           .w600,
                                                    //                 ),
                                                    //               ),
                                                    //               const SizedBox(
                                                    //                   height:
                                                    //                       5),
                                                    //               Expanded(
                                                    //                 child:
                                                    //                     ClipRRect(
                                                    //                   borderRadius:
                                                    //                       BorderRadius.circular(
                                                    //                           15),
                                                    //                   child: Image
                                                    //                       .network(
                                                    //                     "${Network.url}/storage/${pain[0].products[0].photo[0].location}",
                                                    //                     fit: BoxFit
                                                    //                         .cover,
                                                    //                   ),
                                                    //                 ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    // const SizedBox(width: 10),
                                                    // eau.isEmpty
                                                    //     ? const SizedBox()
                                                    //     : GestureDetector(
                                                    //         onTap: () {
                                                    //           showModalBottomSheet(
                                                    //             isScrollControlled:
                                                    //                 true,
                                                    //             backgroundColor:
                                                    //                 Colors
                                                    //                     .transparent,
                                                    //             constraints:
                                                    //                 BoxConstraints(
                                                    //               maxHeight: size
                                                    //                   .height,
                                                    //             ),
                                                    //             context:
                                                    //                 context,
                                                    //             builder: (_) =>
                                                    //                 BackdropFilter(
                                                    //               filter: ImageFilter
                                                    //                   .blur(
                                                    //                       sigmaX:
                                                    //                           0,
                                                    //                       sigmaY:
                                                    //                           0),
                                                    //               child:
                                                    //                   QtyPage(
                                                    //                 fromGeorgettes:
                                                    //                     true,
                                                    //                 label:
                                                    //                     "Quantité",
                                                    //                 georgettesQty:
                                                    //                     1,
                                                    //                 prod: eau[0]
                                                    //                     .products[0],
                                                    //                 date: widget
                                                    //                     .date
                                                    //                     .toString(),
                                                    //                 menuId: widget
                                                    //                     .menu
                                                    //                     .menu![
                                                    //                         0]
                                                    //                     .menuID,
                                                    //                 day: int.parse(
                                                    //                     widget
                                                    //                         .menu
                                                    //                         .key
                                                    //                         .toString()),
                                                    //                 categoryId:
                                                    //                     eauData
                                                    //                         .first
                                                    //                         .id,
                                                    //               ),
                                                    //             ),
                                                    //           );
                                                    //         },
                                                    //         child: SizedBox(
                                                    //           width: 200,
                                                    //           child: Column(
                                                    //             crossAxisAlignment:
                                                    //                 CrossAxisAlignment
                                                    //                     .start,
                                                    //             children: [
                                                    //               Text(
                                                    //                 eau[0].name,
                                                    //                 style:
                                                    //                     const TextStyle(
                                                    //                   fontSize:
                                                    //                       16,
                                                    //                   color:
                                                    //                       kcPrimary,
                                                    //                   fontWeight:
                                                    //                       FontWeight
                                                    //                           .w600,
                                                    //                 ),
                                                    //               ),
                                                    //               const SizedBox(
                                                    //                   height:
                                                    //                       5),
                                                    //               Expanded(
                                                    //                 child:
                                                    //                     ClipRRect(
                                                    //                   borderRadius:
                                                    //                       BorderRadius.circular(
                                                    //                           15),
                                                    //                   child: Image
                                                    //                       .network(
                                                    //                     "${Network.url}/storage/${eau[0].products[0].photo[0].location}",
                                                    //                     fit: BoxFit
                                                    //                         .cover,
                                                    //                   ),
                                                    //                 ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    const SizedBox(width: 10),
                                                    drinks.isEmpty
                                                        ? const SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxHeight:
                                                                            size.height),
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              0,
                                                                          sigmaY:
                                                                              0),
                                                                  child:
                                                                      DrinkPage(
                                                                    data:
                                                                        drinks,
                                                                    day: int.parse(
                                                                        widget
                                                                            .menu
                                                                            .key
                                                                            .toString()),
                                                                    menuId: widget
                                                                        .menu
                                                                        .menu![
                                                                            i]
                                                                        .id,
                                                                    sched: widget
                                                                        .menu
                                                                        .menu![
                                                                            i]
                                                                        .schedule,
                                                                    categoryId:
                                                                        drinkData
                                                                            .first
                                                                            .id,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: SizedBox(
                                                              width: 200,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    drinks[0]
                                                                        .name,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color:
                                                                          kcPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Expanded(
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child: Image
                                                                          .network(
                                                                        "${Network.url}/storage/${drinks[0].products[0].photo[0].location}",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    const SizedBox(width: 10),
                                                    georgettes.isEmpty
                                                        ? const SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                constraints:
                                                                    BoxConstraints(
                                                                  maxHeight: size
                                                                      .height,
                                                                ),
                                                                context:
                                                                    context,
                                                                builder: (_) =>
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              0,
                                                                          sigmaY:
                                                                              0),
                                                                  child:
                                                                      QtyPage(
                                                                    fromGeorgettes:
                                                                        true,
                                                                    label:
                                                                        "Quantité",
                                                                    georgettesQty:
                                                                        1,
                                                                    prod: georgettes[
                                                                            0]
                                                                        .products[0],
                                                                    date: widget
                                                                        .date
                                                                        .toString(),
                                                                    menuId: widget
                                                                        .menu
                                                                        .menu![
                                                                            0]
                                                                        .menuID,
                                                                    day: int.parse(
                                                                        widget
                                                                            .menu
                                                                            .key
                                                                            .toString()),
                                                                    categoryId:
                                                                        georgettesData
                                                                            .first
                                                                            .id,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: SizedBox(
                                                              width: 200,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    georgettes[
                                                                            0]
                                                                        .name,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color:
                                                                          kcPrimary,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  Expanded(
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child: Image
                                                                          .network(
                                                                        "${Network.url}/storage/${georgettes[0].products[0].photo[0].location}",
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 50),
                      itemCount: widget.menu.menu!.length,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child:
                              SvgPicture.asset("assets/icons/Vector (1).svg"),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/cart.png',
                                    color: kcPrimary,
                                    width: 25,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Poursuivre ma commande",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: kcPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 60,
                              width: size.width * .7,
                              margin: const EdgeInsets.symmetric(vertical: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kcPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(90),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LandingPage(ind: 2)),
                                      (Route<dynamic> route) => false);
                                },
                                child: const Text(
                                  "VALIDER\nMA COMMANDE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LandingPage(ind: 3)),
                                    (Route<dynamic> route) => false);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/info.svg"),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Plus d’informations \ndans l’espace Ty-Lunch",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: kcPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: kcPrimary,
                  unselectedItemColor: secondaryColor,
                  selectedFontSize: 12,
                  showUnselectedLabels: true,
                  selectedLabelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/icons/menu.svg",
                          color: secondaryColor),
                      label: 'Menus',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset("assets/icons/user.svg",
                          color: secondaryColor),
                      label: 'Profil',
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 30,
                        child: Stack(
                          children: [
                            SvgPicture.asset("assets/icons/cart.svg"),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: SizedBox(
                                  height: 17,
                                  width: 17,
                                  child: StreamBuilder<List<NewCartModel>>(
                                    stream: _cartViewModel.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          !snapshot.hasError) {
                                        if (snapshot.data!.isNotEmpty) {
                                          final List<NewCartModel> result =
                                              snapshot.data!;
                                          final int cartLength =
                                              getCartLength().getLength(result);
                                          return Container(
                                            width: 22,
                                            height: 22,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "$cartLength",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      return Container();
                                    },
                                  )),
                            )
                          ],
                        ),
                      ),
                      label: 'Mon Panier',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "assets/icons/ty.svg",
                        color: secondaryColor,
                      ),
                      label: 'Ty-Lunch',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
