// ignore_for_file: avoid_print, must_be_immutable, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/datacacher.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/new_cart_model.dart';
import 'package:tylunch/services/api/authentication.dart';
import 'package:tylunch/services/api/formula.dart';
import 'package:tylunch/services/api/menu.dart';
import 'package:tylunch/services/api/order.dart';
import 'package:tylunch/services/api/payment.dart';
import 'package:tylunch/services/database.dart';
import 'package:tylunch/services/firebasemessaging.dart';
import 'package:tylunch/view/home.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/profil.dart';
import 'package:tylunch/view/tylunch_faq.dart';
import 'package:tylunch/viewmodel/cart.dart';
import '../global/cartlength.dart';
import '../model/weekdays.dart';
import 'cart.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key, this.ind = 0, this.week, this.menu, this.date});
  final int ind;
  String? week;
  DateTime? date;
  final WeekdaysModel? menu;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final DatabaseServices dbhandler = DatabaseServices.instance;
  late final PageController _controller;
  final Authentication auth = Authentication();
  final MenuApi menu = MenuApi();
  final FormulaApi formula = FormulaApi();
  final OrderAPI order = OrderAPI();
  final PaymentAPI payment = PaymentAPI();
  late int selectedIndex;
  final PushNotification notif = PushNotification.instance;
  final CartViewModel _cartViewModel = CartViewModel.instance;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      _controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    selectedIndex = widget.ind;
    print(selectedIndex);
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final DataCacher _cacher = DataCacher.instance;
  init() async {
    setState(() {
      accesstoken = _cacher.token;
    });
    await auth.getUserDetails().then((value) async {
      if (value != null) {
        print("VALUE: $value");
        loggedUser = value;
        if (mounted) setState(() {});
        return;
      }
      await Fluttertoast.showToast(
        msg: "Utilisateur non trouvé, veuillez reinscrire",
      );
      _cacher.deleteToken();
      loggedUser = null;
      await Navigator.pushReplacementNamed(context, "/login_page");
    });
    await notif.init(context, loggedUser!.id, "$accesstoken");
    await dbhandler.retrieve();
    await menu.getNextWeekMenu().then((value) {
      print("VALUEEE IN NEXT WEEK MENU IN API: $value");
      if (value!.showNextWeekMenus == true) {
        print("FOR NEXTWEEK");
        return menu.getMenuByDate(date: value.nextWeekMonday);
      } else {
        print("THIS WEEK");
        return menu.getMenu();
      }
    });
    await formula.getFormula();
    // await menu.getMenu();
    await menu.getCategory();
    await menu.getProduct();
    await order.getOrderHistory();
    await payment.getCard();
  }

  late final List<Widget> _pages = <Widget>[
    const HomePage(),
    // MenuPage(
    //     week: widget.week ?? "",
    //     menu: widget.menu!,
    //     date: widget.date ?? DateTime.now()),
    ProfilPage(
      onPagePressed: (int page) async {
        setState(() {
          selectedIndex = page;
        });
        await _controller.animateToPage(
          page,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    ),
    const CartPage(),
    const TyLunchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (loggedUser == null) {
      return Scaffold(
        body: Center(
          child: CustomWidget().loader(),
        ),
      );
    } else {
      return Scaffold(
        body: PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => _pages[selectedIndex],
        ),
        bottomNavigationBar: loggedUser == null
            ? null
            : Container(
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
                        icon: SvgPicture.asset(
                          "assets/icons/menu.svg",
                          color: secondaryColor,
                        ),
                        label: 'Menus',
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons/user.svg",
                          color: secondaryColor,
                        ),
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
                                                getCartLength()
                                                    .getLength(result);
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
                                    )
                                    // CustomWidget().cartQty(),
                                    ),
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
              ),
      );
    }
  }
}
