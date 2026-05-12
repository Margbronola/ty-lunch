import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/model/payment.dart';
import 'package:tylunch/view/cart.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final OrderHistoryViewModel _viewModel = OrderHistoryViewModel.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
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
              SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomWidget().title(
                        t1: "P",
                        t2: "AIEMENT",
                        s1: 33,
                        s2: 25,
                      ),
                    ),
                    const SizedBox(height: 15),
                    StreamBuilder<List<OrderHistoryModel>>(
                      stream: _viewModel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          if (snapshot.data!.isNotEmpty) {
                            final List<OrderHistoryModel> result =
                                snapshot.data!;
                            return ListView.separated(
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemCount: result.length,
                              itemBuilder: (_, i) {
                                final List<PaymentModel> payment =
                                    result[i].payments;

                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    reverse: true,
                                    itemCount: payment.length,
                                    itemBuilder: (_, x) {
                                      return ListTile(
                                        contentPadding: const EdgeInsets.only(
                                            right: 20, left: 20),
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: secondaryColor,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            payment[x].paymentmethod ==
                                                    "credit_points"
                                                ? "CP"
                                                : "B",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ),
                                        title: Text(
                                          payment[x].reference,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Note:  ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text(
                                                  payment[x].note,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              DateFormat("MMM dd, yyyy")
                                                  .format(payment[x].date),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          "${payment[x].amount.toStringAsFixed(2)}€",
                                          style: const TextStyle(
                                            color: kcPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, __) => const Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(
                                color: Colors.grey,
                              ),
                            );
                          }
                        }
                        return const Center(
                          child: Text("Pas de données disponible"),
                        );
                      },
                    )
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
