import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/items.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/view/cart.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final OrderHistoryViewModel _orderHistoryViewModel =
      OrderHistoryViewModel.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/Layer 3.png',
                    fit: BoxFit.fitWidth,
                    width: double.maxFinite,
                  ),
                  CustomWidget().cartQty(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const CartPage(),
                          type: PageTransitionType.rightToLeftWithFade,
                        ),
                      );
                    },
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
                ],
              ),
              Container(
                width: size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget().title(
                      t1: "H",
                      t2: "ISTORIQUE DES COMMANDES",
                      s1: 30,
                      s2: 20,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Qty",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Repas",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
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
                                snapshot.data!;
                            return Align(
                              alignment: Alignment.topCenter,
                              child: ListView.separated(
                                shrinkWrap: true,
                                reverse: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: order.length,
                                itemBuilder: (_, i) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateFormat("MMM dd, yyyy")
                                              .format(order[i].createdAt),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.all(0),
                                          itemCount: order[i].items.length,
                                          itemBuilder: (_, x) {
                                            final List<ItemsModel> items =
                                                order[i].items;
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "x${items[x].qty}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Tooltip(
                                                    message: items[x]
                                                            .product
                                                            ?.dishName ??
                                                        items[x].formula!.name,
                                                    child: Text(
                                                      items[x]
                                                              .product
                                                              ?.dishName ??
                                                          items[x]
                                                              .formula!
                                                              .name,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          separatorBuilder: ((context, index) =>
                                              const SizedBox(height: 5)),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.grey.shade200,
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
