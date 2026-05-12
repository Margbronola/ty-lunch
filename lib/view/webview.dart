// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/dialog.dart';
import 'package:tylunch/global/network.dart';
import 'package:tylunch/model/cartprod.dart';
import 'package:tylunch/services/api/payment.dart';
import 'package:tylunch/view/landing.dart';
import 'package:tylunch/view/paymentsuccessful.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../model/new_cart_model.dart';
import '../services/database.dart';

class WebViewPage extends StatefulWidget {
  final String htmlpage;
  final List<NewCartModel> cart;
  final String selectedconnecs;
  const WebViewPage(
      {super.key,
      required this.htmlpage,
      required this.cart,
      required this.selectedconnecs});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final DatabaseServices db = DatabaseServices.instance;
  final PaymentAPI _paymentAPI = PaymentAPI();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 254, 254))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("PAGE STARTED: $url");

            // if (widget.selectedconnecs == "edenred") {
            //   final parsedUrl = Uri.parse(url);

            //   if (url.contains("edenred/?code=")) {
            //     var urlParse = parsedUrl.queryParametersAll;
            //     print("URLPARSE CODE: ${urlParse["code"]}");

            //     _paymentAPI
            //         .edenredToken(code: urlParse["code"].toString())
            //         .then((value) {
            //       print("VALUE PARSE: $value");
            //       _paymentAPI
            //           .payEdenred(
            //               accessToken: value!.accessToken,
            //               refreshToken: value.refreshToken)
            //           .then((value) {
            //             print("VALUE RETURN FROM PAY EDENRED: $value");
            //         if (value!.contains("success") || value.contains("true")) {
            //           for (NewCartModel cart in widget.cart) {
            //             for (CartProduct prod in cart.products) {
            //               /// delete product
            //               db.deleteProduct(
            //                   prodId: prod.productId, cartId: cart.id);
            //             }
            //           }
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     const PaymentSuccessfulPage()),
            //           );
            //         } else if (value.contains("LIMIT_EXCEEDED") ||
            //             value.contains("false")) {
            //           MyDialog().scaleDialog(
            //             context,
            //             child: Material(
            //               color: Colors.transparent,
            //               elevation: 0,
            //               child: Container(
            //                 width: double.infinity,
            //                 height: double.infinity,
            //                 decoration: const BoxDecoration(
            //                   color: Colors.white,
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(30),
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       const SizedBox(height: 20),
            //                       const Center(
            //                         child: Text(
            //                           "Pas assez d'équilibre",
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 18, color: kcPrimary),
            //                         ),
            //                       ),
            //                       const SizedBox(height: 40),
            //                       Container(
            //                         height: 55,
            //                         width: 300,
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 20),
            //                         child: ElevatedButton(
            //                           style: ElevatedButton.styleFrom(
            //                             backgroundColor: kcPrimary,
            //                             shape: RoundedRectangleBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(90),
            //                             ),
            //                           ),
            //                           onPressed: () {
            //                             Navigator.pushAndRemoveUntil(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                     builder: (context) =>
            //                                         LandingPage(ind: 2)),
            //                                 (Route<dynamic> route) => false);
            //                           },
            //                           child: Text(
            //                             "annuler".toUpperCase(),
            //                             style: const TextStyle(
            //                               color: Colors.white,
            //                               fontSize: 14,
            //                               // fontWeight: FontWeight.w800,
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           );
            //         }
            //       });
            //     });
            //   } else if (url.contains("session/logout")) {
            //     print("ORDER  CANCEL");
            //     Fluttertoast.showToast(msg: "Commande annulée");
            //     Navigator.pushAndRemoveUntil(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => LandingPage(ind: 2)),
            //         (Route<dynamic> route) => false);
            //   // } else {
            //     // Fluttertoast.showToast(
            //     //     msg:
            //     //         "Une erreur s'est produite lors de l'exécution de cette opération");
            //     // Navigator.pushAndRemoveUntil(
            //     //     context,
            //     //     MaterialPageRoute(
            //     //         builder: (context) => LandingPage(ind: 2)),
            //     //     (Route<dynamic> route) => false);
            //   }
            // }
          },
          onPageFinished: (url) {
            print('Page finished loading: $url');
            if (widget.selectedconnecs == "edenred") {
              print("PAYMENT THROUGH EDENRED");
              final parsedUrl = Uri.parse(url);

              if (url.contains("edenred/?code=")) {
                var urlParse = parsedUrl.queryParametersAll;
                print("URLPARSE CODE: ${urlParse["code"]}");

                _paymentAPI
                    .edenredToken(code: urlParse["code"].toString())
                    .then((value) {
                  print("VALUE PARSE: $value");
                  _paymentAPI
                      .payEdenred(
                          accessToken: value!.accessToken,
                          refreshToken: value.refreshToken)
                      .then((value) {
                    print("VALUE RETURN FROM PAY EDENRED: $value");
                    if (value!.contains("success") || value.contains("true")) {
                      for (NewCartModel cart in widget.cart) {
                        for (CartProduct prod in cart.products) {
                          /// delete product
                          db.deleteProduct(
                              prodId: prod.productId, cartId: cart.id);
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PaymentSuccessfulPage()),
                      );
                    } else if (value.contains("LIMIT_EXCEEDED") ||
                        value.contains("false")) {
                      MyDialog().scaleDialog(
                        context,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  const Center(
                                    child: Text(
                                      "Pas assez d'équilibre",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18, color: kcPrimary),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    height: 55,
                                    width: 300,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kcPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(90),
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
                                      child: Text(
                                        "annuler".toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else  {
                      Fluttertoast.showToast(
                          msg:
                              "Une erreur s'est produite lors de l'exécution de cette opération");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage(ind: 2)),
                          (Route<dynamic> route) => false);
                    }
                  });
                });
              } else if (url.contains("session/logout")) {
                print("ORDER  CANCEL");
                Fluttertoast.showToast(msg: "Commande annulée");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LandingPage(ind: 2)),
                    (Route<dynamic> route) => false);
              }
            } else {
              // if (url.contains("https://back.tylunch.studioseizh.com")) {
              if (url.contains(Network.url)) {
                // url.contains("https://recette-tpeweb.e-transactions.fr/php/")) {
                // if (url.contains("https://admin.ty-lunch.fr")) {
                print("SA IF SUMULOD");
                if (url.contains(
                    // "https://admin.ty-lunch.fr/api/front/order/payment/status-cancel")) {
                    "${Network.api}/front/order/payment/status-cancel")) {
                  // "https://tylunch.studioseizh.com/api/front/order/payment/status-cancel")) {
                  print("ORDER  CANCEL");
                  Fluttertoast.showToast(msg: "Commande annulée");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LandingPage(ind: 2)),
                      (Route<dynamic> route) => false);
                } else {
                  print("ORDER  SUCCESS");
                  print("URL RETURN: $url");

                  for (NewCartModel cart in widget.cart) {
                    for (CartProduct prod in cart.products) {
                      /// delete product
                      db.deleteProduct(prodId: prod.productId, cartId: cart.id);
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentSuccessfulPage()),
                  );
                }
              } else {
                print("SA ELSE SUMULOD");
              }
            }
          },
        ),
      )
      ..loadHtmlString(widget.htmlpage);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.clearLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}



                // MyDialog().scaleDialog(
                //   context,
                //   child: Material(
                //     color: Colors.transparent,
                //     elevation: 0,
                //     child: Container(
                //       width: double.infinity,
                //       height: double.infinity,
                //       decoration: const BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(5),
                //           topRight: Radius.circular(5),
                //           bottomLeft: Radius.circular(10),
                //           bottomRight: Radius.circular(10),
                //         ),
                //       ),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           const SizedBox(height: 15),
                //           SvgPicture.asset("assets/icons/Frame 2612.svg"),
                //           const SizedBox(height: 20),
                //           const Text(
                //             "Paiement terminé",
                //             style: TextStyle(
                //                 fontSize: 30,
                //                 fontWeight: FontWeight.w800,
                //                 color: kcPrimary),
                //           ),
                //           const SizedBox(height: 30),
                //           Container(
                //             height: 55,
                //             padding: const EdgeInsets.symmetric(horizontal: 20),
                //             child: ElevatedButton(
                //               style: ElevatedButton.styleFrom(
                //                 backgroundColor: kcPrimary,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(90),
                //                 ),
                //               ),
                //               onPressed: () {
                //                 db.retrieve();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             LandingPage(ind: 2)),
                //     (Route<dynamic> route) => false);
                //               },
                //               child: Text(
                //                 "Retour à l’accueil".toUpperCase(),
                //                 style: const TextStyle(
                //                   color: Colors.white,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w800,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );