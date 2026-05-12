// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/widget.dart';
import '../global/color.dart';
import '../global/network.dart';
import '../model/menu.dart';
import '../model/product.dart';
import '../model/weekdays.dart';
import '../model/weeklymenu.dart';
import '../viewmodel/weekly_menu.dart';
import 'menu.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeeklyMenuViewModel _weeklyMenu = WeeklyMenuViewModel.instance;
  final CustomWidget cw = CustomWidget();
  bool expanded = false;
  late String weekDate = "";
  late String weekDate1 = "";

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<WeeklyMenuModel>(
        stream: _weeklyMenu.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            final WeeklyMenuModel result = snapshot.data!;

            final List<WeekdaysModel>? menu1 = result.menus;
            print("MENU!: $menu1");

            return SizedBox(
              width: size.width,
              height: size.height,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 120,
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/images/circ 5.svg",
                            color: secondaryColor,
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child:
                                SvgPicture.asset("assets/icons/Ty-Lunch.svg"),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Du ",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: kcPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'CraftRounded',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: result.startdate,
                                        style: const TextStyle(
                                            fontSize: 32,
                                            color: secondaryColor),
                                      ),
                                      const TextSpan(text: " au "),
                                      TextSpan(
                                        text: result.endDate,
                                        style: const TextStyle(
                                            fontSize: 32,
                                            color: secondaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${result.month}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: kcPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 170,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/icons/Vector.svg"),
                          const SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SvgPicture.asset(
                                          "assets/icons/pin.svg")),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pays de Lorient",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: kcPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Livraison à partir du mardi\n& commande la veille avant 18h00",
                                        style: TextStyle(color: kcPrimary),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: SvgPicture.asset(
                                          "assets/icons/pin.svg")),
                                  const SizedBox(width: 10),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pays de Quimper",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: kcPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Commande du jour jusqu’à 10h30",
                                        style: TextStyle(color: kcPrimary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    menu1!.where((element) => element.menu!.isNotEmpty).isEmpty
                        ? Container(
                            height: size.height * .45,
                            alignment: Alignment.center,
                            child: const Text("Pas de menu disponible",
                                style:
                                    TextStyle(color: kcPrimary, fontSize: 20)),
                          )
                        : ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: SvgPicture.asset(
                                      "assets/icons/upper.svg",
                                      color: secondaryColor.withOpacity(0.3),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (c, i) {
                                      final List<MenuModel> menuData = menu1[i]
                                          .menu!
                                          // .where((element) =>
                                          //     element.details.isCleared == 0)
                                          .toList();

                                      print("HOME MENU DATAAA: $menuData");

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: menuData.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          itemBuilder: (c, m) {
                                            final MenuModel menus = menuData[m];

                                            if (loggedUser!.company.deliveryType ==
                                                    1
                                                ? DateFormat("yyyy-MM-dd")
                                                            .format(
                                                                DateTime.now())
                                                            .compareTo(DateFormat("yyyy-MM-dd")
                                                                .format(DateTime.parse(
                                                                    menus
                                                                        .schedule))) ==
                                                        0
                                                    ? DateFormat("yyyy-MM-dd").format(DateTime.now()).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.parse(menus.schedule))) ==
                                                            0 &&
                                                        DateFormat("HH:mm").format(DateTime.now()).compareTo("10:30") <
                                                            0
                                                    : DateFormat("yyyy-MM-dd")
                                                            .format(DateTime.parse(menus.schedule))
                                                            .compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >=
                                                        0
                                                : DateFormat("yyyy-MM-dd").format(DateTime.parse(menus.schedule)).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >= 0
                                                    ? DateFormat("HH:mm").format(DateTime.now()).compareTo("18:00") < 0
                                                        ? DateFormat("HH:mm").format(DateTime.now()).compareTo("18:00") < 0 && DateFormat("yyyy-MM-dd").format(DateTime.parse(menus.schedule)).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)))) >= 0
                                                        : DateFormat("yyyy-MM-dd").format(DateTime.parse(menus.schedule)).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 2)))) >= 0
                                                    : DateFormat("yyyy-MM-dd").format(DateTime.parse(menus.schedule)).compareTo(DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 2)))) >= 0) {
                                              menu1[i].menu!.isEmpty
                                                  ? ""
                                                  : weekDate = DateFormat(
                                                          'EEEE', 'fr_FR')
                                                      .format(DateTime.parse(
                                                          menu1[i]
                                                              .menu!
                                                              .first
                                                              .schedule));

                                              final List<
                                                      ProductModel>
                                                  starter = menus.details.categories
                                                      .where((element) =>
                                                          element.name.contains(
                                                              "Entrée") ||
                                                          element.name.contains(
                                                              "entrée") ||
                                                          element.name.contains(
                                                              "starter") ||
                                                          element.name.contains(
                                                              "Starter"))
                                                      .expand((element) =>
                                                          element.products)
                                                      .toList();

                                              final List<ProductModel>
                                                  surLePouce = menus
                                                      .details.categories
                                                      .where((element) =>
                                                          element.name.contains(
                                                              "Sur le pouce") ||
                                                          element.name.contains(
                                                              "sur le pouce"))
                                                      .expand((element) =>
                                                          element.products)
                                                      .toList();

                                              final List<ProductModel> main = menus
                                                  .details.categories
                                                  .where((element) =>
                                                      element.name
                                                          .contains("Plat") ||
                                                      element.name
                                                          .contains("plat") ||
                                                      element.name
                                                          .contains("main") ||
                                                      element.name
                                                          .contains("Main"))
                                                  .expand((element) =>
                                                      element.products)
                                                  .toList();

                                              final List<ProductModel> dessert =
                                                  menus.details.categories
                                                      .where((element) =>
                                                          element.name.contains(
                                                              "Dessert") ||
                                                          element.name.contains(
                                                              "dessert"))
                                                      .expand((element) =>
                                                          element.products)
                                                      .toList();

                                              return Column(
                                                children: [
                                                  const SizedBox(height: 40),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 60,
                                                              width: 1),
                                                          const SizedBox(
                                                              height: 5),
                                                          SizedBox(
                                                            height: 316,
                                                            child: Center(
                                                              child: RotatedBox(
                                                                quarterTurns: 3,
                                                                child:
                                                                    cw.bodytext(
                                                                  label:
                                                                      "Ty-${weekDate[0].toUpperCase()}${weekDate.substring(1)}",
                                                                  size: 28,
                                                                  color:
                                                                      kcPrimary,
                                                                  weight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            main.isEmpty
                                                                ? Container()
                                                                : Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            70,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            SvgPicture.asset("assets/images/plat-logo.svg",
                                                                                width: 60,
                                                                                height: 60),
                                                                            Expanded(
                                                                              child: Text(
                                                                                "${main[0].dishName[0].toUpperCase()}${main[0].dishName.substring(1)}",
                                                                                style: const TextStyle(
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                                maxLines: 2,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              5),
                                                                      SizedBox(
                                                                        width:
                                                                            316,
                                                                        height:
                                                                            316,
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => MenuPage(
                                                                                    menu: result.menus![i],
                                                                                    date: DateTime.parse(result.menus![i].menu![0].schedule),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                cw.shimmerLoading(kcPrimary, 316),
                                                                                if (menus.details.categories.isNotEmpty && main.isNotEmpty && main[0].photo.isNotEmpty) ...{
                                                                                  Image.network(
                                                                                    "${Network.url}/storage/${main[0].photo[0].location}",
                                                                                    fit: BoxFit.cover,
                                                                                    width: 316,
                                                                                    height: 316,
                                                                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                                                                      "assets/images/placeholder.jpeg",
                                                                                      fit: BoxFit.cover,
                                                                                      width: 316,
                                                                                      height: 316,
                                                                                    ),
                                                                                  )
                                                                                } else ...{
                                                                                  Image.asset(
                                                                                    "assets/images/placeholder.jpeg",
                                                                                    fit: BoxFit.cover,
                                                                                    width: 316,
                                                                                    height: 316,
                                                                                  )
                                                                                }
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              children: [
                                                                const Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Entrée",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      "Dessert",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      "Sur le pouce",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    width: 15),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        starter.isEmpty
                                                                            ? ""
                                                                            : "${starter[0].dishName[0].toUpperCase()}${starter[0].dishName.substring(1)}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                          dessert.isEmpty
                                                                              ? ""
                                                                              : "${dessert[0].dishName[0].toUpperCase()}${dessert[0].dishName.substring(1)}",
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  15),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                      const SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                          surLePouce.isEmpty
                                                                              ? ""
                                                                              : "${surLePouce[0].dishName[0].toUpperCase()}${surLePouce[0].dishName.substring(1)}",
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  15),
                                                                          overflow:
                                                                              TextOverflow.ellipsis)
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            dessert.length >=
                                                                        3 ||
                                                                    starter.length >=
                                                                        3 ||
                                                                    surLePouce
                                                                            .length >=
                                                                        3
                                                                ? const Text(
                                                                    "D’autres propositions dans découvrir",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15))
                                                                : const SizedBox(),
                                                            const SizedBox(
                                                                height: 10),
                                                            Center(
                                                              child: SizedBox(
                                                                height: 55,
                                                                width: 220,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        kcPrimary,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              90),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => MenuPage(
                                                                            menu:
                                                                                menu1[i],
                                                                            date: DateTime.parse(result.menus![i].menu![0].schedule)),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "DÉCOUVRIR",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            }
                                            return Container();
                                          });
                                    },
                                    itemCount: menu1.length,
                                  ),
                                ],
                              ),

                              /////   FOR THE PAST MENU CODE   /////
                              Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: SvgPicture.asset(
                                      "assets/icons/lower.svg",
                                      color: secondaryColor.withOpacity(0.3),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      itemCount: menu1.length,
                                      itemBuilder: (c, q) {
                                        final List<MenuModel> menuData =
                                            menu1[q].menu!.toList();

                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: menuData.length,
                                          itemBuilder: (c, m) {
                                            final MenuModel menus = menuData[m];

                                            weekDate1 =
                                                DateFormat('EEEE', 'fr_FR')
                                                    .format(DateTime.parse(
                                                        menu1[q]
                                                            .menu!
                                                            .first
                                                            .schedule));

                                            final List<
                                                    ProductModel>
                                                starter = menus.details.categories
                                                    .where((element) =>
                                                        element.name.contains(
                                                            "Entrée") ||
                                                        element.name.contains(
                                                            "entrée") ||
                                                        element.name.contains(
                                                            "starter") ||
                                                        element.name.contains(
                                                            "Starter"))
                                                    .expand((element) =>
                                                        element.products)
                                                    .toList();

                                            final List<ProductModel>
                                                surLePouce = menus
                                                    .details.categories
                                                    .where((element) =>
                                                        element.name.contains(
                                                            "Sur le pouce") ||
                                                        element.name.contains(
                                                            "sur le pouce"))
                                                    .expand((element) =>
                                                        element.products)
                                                    .toList();

                                            final List<ProductModel> main =
                                                menus.details.categories
                                                    .where((element) =>
                                                        element.name
                                                            .contains("Plat") ||
                                                        element.name
                                                            .contains("plat") ||
                                                        element.name
                                                            .contains("main") ||
                                                        element.name
                                                            .contains("Main"))
                                                    .expand((element) =>
                                                        element.products)
                                                    .toList();

                                            final List<ProductModel>
                                                dessert = menus
                                                    .details.categories
                                                    .where((element) =>
                                                        element
                                                            .name
                                                            .contains(
                                                                "Dessert") ||
                                                        element
                                                            .name
                                                            .contains(
                                                                "dessert"))
                                                    .expand((element) =>
                                                        element.products)
                                                    .toList();

                                            //ig check if iscleared an menu or diri
                                            if (menus.details.isCleared == 1) {
                                              print(
                                                  "MENU THAT IS CLEARED: ${menus.details.categories}");
                                              return Column(children: [
                                                const SizedBox(height: 30),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 60,
                                                            width: 1),
                                                        const SizedBox(
                                                            height: 5),
                                                        SizedBox(
                                                          height: 316,
                                                          child: Center(
                                                            child: RotatedBox(
                                                              quarterTurns: 3,
                                                              child:
                                                                  cw.bodytext(
                                                                label:
                                                                    "Ty-${weekDate1[0].toUpperCase()}${weekDate1.substring(1)}",
                                                                size: 28,
                                                                color:
                                                                    kcPrimary,
                                                                weight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          main.isEmpty
                                                              ? Container()
                                                              : Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SvgPicture.asset(
                                                                              "assets/images/plat-logo.svg",
                                                                              width: 60,
                                                                              height: 60),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              "${main[0].dishName[0].toUpperCase()}${main[0].dishName.substring(1)}",
                                                                              style: const TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    SizedBox(
                                                                      width:
                                                                          316,
                                                                      height:
                                                                          316,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            cw.shimmerLoading(kcPrimary,
                                                                                316),
                                                                            if (menus.details.categories.isNotEmpty &&
                                                                                main.isNotEmpty &&
                                                                                main[0].photo.isNotEmpty) ...{
                                                                              Stack(
                                                                                children: [
                                                                                  Image.network(
                                                                                    "${Network.url}/storage/${main[0].photo[0].location}",
                                                                                    fit: BoxFit.cover,
                                                                                    height: 316,
                                                                                    width: 316,
                                                                                    errorBuilder: (_, o, s) => Image.asset(
                                                                                      "assets/images/placeholder.jpeg",
                                                                                      fit: BoxFit.cover,
                                                                                      height: 316,
                                                                                      width: 316,
                                                                                    ),
                                                                                  ),
                                                                                  Positioned.fill(
                                                                                    child: Container(
                                                                                      color: Colors.white.withOpacity(.7),
                                                                                      alignment: Alignment.center,
                                                                                      child: Transform.rotate(
                                                                                        angle: -15 * math.pi / 180,
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color.fromARGB(255, 180, 182, 220),
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                                          child: const Text(
                                                                                            "JOURNÉE TERMINÉE",
                                                                                            style: TextStyle(
                                                                                              color: kcPrimary,
                                                                                              fontWeight: FontWeight.w800,
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            } else ...{
                                                                              Stack(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    "assets/images/placeholder.jpeg",
                                                                                    fit: BoxFit.cover,
                                                                                    height: 316,
                                                                                    width: 316,
                                                                                  ),
                                                                                  Positioned.fill(
                                                                                    child: Container(
                                                                                      color: Colors.white.withOpacity(.7),
                                                                                      alignment: Alignment.center,
                                                                                      child: SvgPicture.asset(
                                                                                        "assets/icons/Frame 2669.svg",
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            },
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            children: [
                                                              const Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Entrée",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Dessert",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "Sur le pouce",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  width: 15),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        starter.isEmpty
                                                                            ? ""
                                                                            : "${starter[0].dishName[0].toUpperCase()}${starter[0].dishName.substring(1)}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                        dessert.isEmpty
                                                                            ? ""
                                                                            : "${dessert[0].dishName[0].toUpperCase()}${dessert[0].dishName.substring(1)}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                    const SizedBox(
                                                                        height:
                                                                            5),
                                                                    Text(
                                                                        surLePouce.isEmpty
                                                                            ? ""
                                                                            : "${surLePouce[0].dishName[0].toUpperCase()}${surLePouce[0].dishName.substring(1)}",
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                        overflow:
                                                                            TextOverflow.ellipsis)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 30)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]);
                                            } else if (loggedUser!
                                                    .company.deliveryType ==
                                                1) {
                                              if (DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.now())
                                                      .compareTo(DateFormat(
                                                              "yyyy-MM-dd")
                                                          .format(DateTime
                                                              .parse(menus
                                                                  .schedule))) ==
                                                  0) {
                                                return DateFormat("HH:mm")
                                                            .format(
                                                                DateTime.now())
                                                            .compareTo(
                                                                "10:30") >
                                                        0
                                                    ? Column(children: [
                                                        const SizedBox(
                                                            height: 30),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                const SizedBox(
                                                                    height: 60,
                                                                    width: 1),
                                                                const SizedBox(
                                                                    height: 5),
                                                                SizedBox(
                                                                  height: 316,
                                                                  child: Center(
                                                                    child:
                                                                        RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child: cw
                                                                          .bodytext(
                                                                        label:
                                                                            "Ty-${weekDate1[0].toUpperCase()}${weekDate1.substring(1)}",
                                                                        size:
                                                                            28,
                                                                        color:
                                                                            kcPrimary,
                                                                        weight:
                                                                            FontWeight.w800,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  main.isEmpty
                                                                      ? Container()
                                                                      : Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 70,
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset("assets/images/plat-logo.svg", width: 60, height: 60),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      "${main[0].dishName[0].toUpperCase()}${main[0].dishName.substring(1)}",
                                                                                      style: const TextStyle(
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            SizedBox(
                                                                              width: 316,
                                                                              height: 316,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    cw.shimmerLoading(kcPrimary, 316),
                                                                                    if (menus.details.categories.isNotEmpty && main.isNotEmpty && main[0].photo.isNotEmpty) ...{
                                                                                      Stack(
                                                                                        children: [
                                                                                          Image.network(
                                                                                            "${Network.url}/storage/${main[0].photo[0].location}",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 316,
                                                                                            width: 316,
                                                                                            errorBuilder: (_, o, s) => Image.asset(
                                                                                              "assets/images/placeholder.jpeg",
                                                                                              fit: BoxFit.cover,
                                                                                              height: 316,
                                                                                              width: 316,
                                                                                            ),
                                                                                          ),
                                                                                          Positioned.fill(
                                                                                            child: Container(
                                                                                              color: Colors.white.withOpacity(.7),
                                                                                              alignment: Alignment.center,
                                                                                              child: Transform.rotate(
                                                                                                angle: -15 * math.pi / 180,
                                                                                                child: Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: const Color.fromARGB(255, 180, 182, 220),
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                  ),
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                                                  child: const Text(
                                                                                                    "JOURNÉE TERMINÉE",
                                                                                                    style: TextStyle(
                                                                                                      color: kcPrimary,
                                                                                                      fontWeight: FontWeight.w800,
                                                                                                      fontSize: 18,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              //  SvgPicture.asset(
                                                                                              //   "assets/icons/Frame 2669.svg",
                                                                                              // ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    } else ...{
                                                                                      Stack(
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            "assets/images/placeholder.jpeg",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 316,
                                                                                            width: 316,
                                                                                          ),
                                                                                          Positioned.fill(
                                                                                            child: Container(
                                                                                              color: Colors.white.withOpacity(.7),
                                                                                              alignment: Alignment.center,
                                                                                              child: SvgPicture.asset(
                                                                                                "assets/icons/Frame 2669.svg",
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    },
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      const Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Entrée",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Dessert",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Sur le pouce",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              15),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(starter.isEmpty ? "" : "${starter[0].dishName[0].toUpperCase()}${starter[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis),
                                                                            const SizedBox(height: 5),
                                                                            Text(dessert.isEmpty ? "" : "${dessert[0].dishName[0].toUpperCase()}${dessert[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis),
                                                                            const SizedBox(height: 5),
                                                                            Text(surLePouce.isEmpty ? "" : "${surLePouce[0].dishName[0].toUpperCase()}${surLePouce[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          30)
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ])
                                                    : Container();
                                              }
                                            } else if (loggedUser!
                                                    .company.deliveryType ==
                                                2) {
                                              if (DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.now())
                                                      .compareTo(DateFormat(
                                                              "yyyy-MM-dd")
                                                          .format(DateTime
                                                              .parse(menus
                                                                  .schedule))) ==
                                                  0) {
                                                return DateFormat("HH:mm")
                                                            .format(
                                                                DateTime.now())
                                                            .compareTo(
                                                                "18:00") >
                                                        0
                                                    ? Column(children: [
                                                        const SizedBox(
                                                            height: 30),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                const SizedBox(
                                                                    height: 60,
                                                                    width: 1),
                                                                const SizedBox(
                                                                    height: 5),
                                                                SizedBox(
                                                                  height: 316,
                                                                  child: Center(
                                                                    child:
                                                                        RotatedBox(
                                                                      quarterTurns:
                                                                          3,
                                                                      child: cw
                                                                          .bodytext(
                                                                        label:
                                                                            "Ty-${weekDate1[0].toUpperCase()}${weekDate1.substring(1)}",
                                                                        size:
                                                                            28,
                                                                        color:
                                                                            kcPrimary,
                                                                        weight:
                                                                            FontWeight.w800,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  main.isEmpty
                                                                      ? Container()
                                                                      : Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 70,
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset("assets/images/plat-logo.svg", width: 60, height: 60),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      "${main[0].dishName[0].toUpperCase()}${main[0].dishName.substring(1)}",
                                                                                      style: const TextStyle(
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                      maxLines: 2,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            SizedBox(
                                                                              width: 316,
                                                                              height: 316,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                child: Stack(
                                                                                  children: [
                                                                                    cw.shimmerLoading(kcPrimary, 316),
                                                                                    if (menus.details.categories.isNotEmpty && main.isNotEmpty && main[0].photo.isNotEmpty) ...{
                                                                                      Stack(
                                                                                        children: [
                                                                                          Image.network(
                                                                                            "${Network.url}/storage/${main[0].photo[0].location}",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 316,
                                                                                            width: 316,
                                                                                            errorBuilder: (_, o, s) => Image.asset(
                                                                                              "assets/images/placeholder.jpeg",
                                                                                              fit: BoxFit.cover,
                                                                                              height: 316,
                                                                                              width: 316,
                                                                                            ),
                                                                                          ),
                                                                                          Positioned.fill(
                                                                                            child: Container(
                                                                                              color: Colors.white.withOpacity(.7),
                                                                                              alignment: Alignment.center,
                                                                                              child: Transform.rotate(
                                                                                                angle: -15 * math.pi / 180,
                                                                                                child: Container(
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: const Color.fromARGB(255, 180, 182, 220),
                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                  ),
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                                                  child: const Text(
                                                                                                    "JOURNÉE TERMINÉE",
                                                                                                    style: TextStyle(
                                                                                                      color: kcPrimary,
                                                                                                      fontWeight: FontWeight.w800,
                                                                                                      fontSize: 18,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    } else ...{
                                                                                      Stack(
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            "assets/images/placeholder.jpeg",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 316,
                                                                                            width: 316,
                                                                                          ),
                                                                                          Positioned.fill(
                                                                                            child: Container(
                                                                                              color: Colors.white.withOpacity(.7),
                                                                                              alignment: Alignment.center,
                                                                                              child: SvgPicture.asset(
                                                                                                "assets/icons/Frame 2669.svg",
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    },
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      const Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Entrée",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Dessert",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "Sur le pouce",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              15),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(starter.isEmpty ? "" : "${starter[0].dishName[0].toUpperCase()}${starter[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis),
                                                                            const SizedBox(height: 5),
                                                                            Text(dessert.isEmpty ? "" : "${dessert[0].dishName[0].toUpperCase()}${dessert[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis),
                                                                            const SizedBox(height: 5),
                                                                            Text(surLePouce.isEmpty ? "" : "${surLePouce[0].dishName[0].toUpperCase()}${surLePouce[0].dishName.substring(1)}",
                                                                                style: const TextStyle(fontSize: 15),
                                                                                overflow: TextOverflow.ellipsis)
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          30)
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ])
                                                    : Container();
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10)
                            ],
                          )
                  ],
                ),
              ),
            );
          }
          return cw.loader();
        },
      ),
    );
  }
}
