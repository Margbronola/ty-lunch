// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/datacacher.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/services/api/authentication.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/changepass.dart';
import 'package:tylunch/view/CONNEXION%20AND%20ACCOUNT/profiledetails.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/user.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key, required this.onPagePressed, this.callback});
  final ValueChanged<int> onPagePressed;
  final ValueChanged<UserModel>? callback;

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final Authentication _authApi = Authentication();
  final DataCacher _cacher = DataCacher.instance;
  final OrderHistoryViewModel _orderHistoryViewModel =
      OrderHistoryViewModel.instance;
  bool isloading = false;
  final Uri _url = Uri.parse('https://tylunch.studioseizh.com/delete-account');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width,
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/images/circ 5.svg",
                            color: secondaryColor,
                          ),
                          const Positioned(
                            top: 10,
                            left: 15,
                            child: Text(
                              "Mon compte",
                              style: TextStyle(
                                fontFamily: 'CraftRounded',
                                fontSize: 27,
                                color: kcPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            widget.onPagePressed(2);
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(0),
                                child: SvgPicture.asset(
                                  "assets/images/cart.svg",
                                  color: kcPrimary,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CustomWidget().cartQty(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Positioned(
                      // top: 20,
                      // right: 20,
                      //   child: CustomWidget().cartQty(
                      //     onPressed: () {
                      //       widget.onPagePressed(2);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lieu de livraison:',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                loggedUser?.company.deliveryLocation ??
                                    "Aucune entreprise",
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Code lieu de livraison:',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                loggedUser?.code ?? "Aucune code d'enterprise",
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nom:',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                              Text(
                                '${loggedUser!.name} ${loggedUser!.lastname}',
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email:',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                loggedUser?.email ?? "Pas de email",
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  color: const Color.fromARGB(255, 249, 249, 249),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        "HISTORIQUE DES COMMANDES",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              "N° de commande",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              "Prix",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      StreamBuilder<List<OrderHistoryModel>>(
                        stream: _orderHistoryViewModel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.hasError) {
                            if (snapshot.data!.isNotEmpty) {
                              snapshot.data!.sort(
                                  (a, b) => a.createdAt.compareTo(b.createdAt));
                              final List<OrderHistoryModel> order =
                                  snapshot.data!.length > 5
                                      ? snapshot.data!
                                          .sublist(snapshot.data!.length - 5)
                                      : snapshot.data!;
                              print("INVOICE: $order");
                              return Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  reverse: true,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      order.length > 10 ? 10 : order.length,
                                  itemBuilder: (_, i) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            DateFormat("dd/MM/yyyy")
                                                .format(order[i].createdAt),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            order[i].commande,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            "${order[i].total.toStringAsFixed(2)} € TTC",
                                            style:
                                                const TextStyle(fontSize: 15),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: ListView.separated(
                                        //     shrinkWrap: true,
                                        //     physics:
                                        //         const NeverScrollableScrollPhysics(),
                                        //     padding: const EdgeInsets.all(0),
                                        //     itemCount: order[i].items.length,
                                        //     itemBuilder: (_, x) {
                                        //       final List<ItemsModel> items =
                                        //           order[i].items;
                                        //       return Row(
                                        //         children: [
                                        //           Text(
                                        //             "${items[x].qty}",
                                        //             style: const TextStyle(
                                        //               color: Colors.black,
                                        //               fontSize: 15,
                                        //               fontWeight:
                                        //                   FontWeight.w700,
                                        //             ),
                                        //           ),
                                        //           const SizedBox(width: 5),
                                        //           Expanded(
                                        //             child: Tooltip(
                                        //               message: items[x]
                                        //                       .product
                                        //                       ?.dishName ??
                                        //                   items[x]
                                        //                       .formula!
                                        //                       .name,
                                        //               child: Text(
                                        //                 items[x]
                                        //                         .product
                                        //                         ?.dishName ??
                                        //                     items[x]
                                        //                         .formula!
                                        //                         .name,
                                        //                 style: const TextStyle(
                                        //                     fontSize: 15),
                                        //                 textAlign:
                                        //                     TextAlign.end,
                                        //                 overflow: TextOverflow
                                        //                     .ellipsis,
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       );
                                        //     },
                                        //     separatorBuilder:
                                        //         (context, index) =>
                                        //             const SizedBox(height: 5),
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              );
                            }
                          }
                          return const Center(
                            child: Text("Pas de données disponible"),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.expand_more_rounded,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/info.svg",
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          "Vos factures sont envoyées par mail. Pour tout besoin de duplicata, contactez-nous sur accueil@ty-Lunch.fr",
                          style: TextStyle(
                            color: kcPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
                  child: Column(
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 225, 225, 225),
                        thickness: 1,
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/lock.png',
                            width: 25,
                            height: 25,
                            color: kcPrimary,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Changer le mot de passe",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: const ChangePasswordPage(),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 225, 225, 225),
                        thickness: 1,
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/user.png',
                            width: 25,
                            height: 25,
                            color: kcPrimary,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Modifier mon profil",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ProfileDetailsPage(
                                    onUpdateCallback: (callback) {
                                      setState(() {
                                        loggedUser!.name = callback.name;
                                        loggedUser!.lastname =
                                            callback.lastname;
                                        loggedUser!.email = callback.email;
                                      });
                                    },
                                  ),
                                  type: PageTransitionType.leftToRight,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 225, 225, 225),
                        thickness: 1,
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/deleteAccount.png',
                            width: 25,
                            height: 25,
                            color: kcPrimary,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Je supprime mon compte",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () async {
                              _launchUrl();
                            },
                          )
                        ],
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 225, 225, 225),
                        thickness: 1,
                        height: 20,
                      ),
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       'assets/icons/card.png',
                      //       width: 25,
                      //       height: 25,
                      //       color: kcPrimary,
                      //     ),
                      //     const SizedBox(width: 10),
                      //     const Text(
                      //       "Enregistrer ma carte\nbancaire",
                      //       style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //     const Expanded(child: SizedBox()),
                      //     IconButton(
                      //       padding: const EdgeInsets.all(0),
                      //       icon: const Icon(Icons.arrow_forward_ios_rounded),
                      //       onPressed: () {
                      //         Navigator.push(
                      //           context,
                      //           PageTransition(
                      //             child: const OneClickPaymentPage(),
                      //             type: PageTransitionType.leftToRight,
                      //           ),
                      //         );
                      //       },
                      //     )
                      //   ],
                      // ),
                      // const Divider(
                      //   color: Color.fromARGB(255, 225, 225, 225),
                      //   thickness: 1,
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    height: 55,
                    width: size.width * .85,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          isloading = true;
                        });

                        _authApi.logout().then((value) {
                          if (value) {
                            _cacher.deleteToken();
                            Navigator.pushReplacementNamed(
                                context, '/login_page');
                          }
                        }).whenComplete(
                          () => setState(() => isloading = false),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/power.png'),
                          const SizedBox(width: 10),
                          const Text(
                            "SE DÉCONNECTER",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isloading ? CustomWidget().loader() : Container()
        ],
      ),
    );
  }
}
