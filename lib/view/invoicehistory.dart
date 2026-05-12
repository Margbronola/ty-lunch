import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/view/cart.dart';
import 'package:tylunch/view/invoiceviewer.dart';
import 'package:tylunch/view/pdfpreview.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';

class InvoiceHistoryPage extends StatefulWidget {
  const InvoiceHistoryPage({super.key});

  @override
  State<InvoiceHistoryPage> createState() => _InvoiceHistoryPageState();
}

class _InvoiceHistoryPageState extends State<InvoiceHistoryPage> {
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
              Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    CustomWidget().title(
                      t1: "F",
                      t2: "ACTURE",
                      s1: 33,
                      s2: 25,
                    ),
                    const SizedBox(height: 15),
                    Row(
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
                            "Invoice",
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
                            "Amount",
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
                    const SizedBox(height: 15),
                    StreamBuilder<List<OrderHistoryModel>>(
                      stream: _viewModel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.hasError) {
                          if (snapshot.data!.isNotEmpty) {
                            snapshot.data!.sort(
                                (a, b) => a.createdAt.compareTo(b.createdAt));
                            final List<OrderHistoryModel> result =
                                snapshot.data!;
                            return ListView.separated(
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemCount: result.length,
                              itemBuilder: (_, i) {
                                return MaterialButton(
                                  onPressed: () async {
                                    await showGeneralDialog(
                                        barrierColor:
                                            Colors.black.withOpacity(0.5),
                                        transitionBuilder:
                                            (context, a1, a2, widget) {
                                          return Transform.scale(
                                            scale: a1.value,
                                            child: Opacity(
                                              opacity: a1.value,
                                              child: AlertDialog(
                                                shape: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      "FRACTURE",
                                                      style: TextStyle(
                                                        color: kcPrimary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PdfPreviewPage(
                                                              orderhistory:
                                                                  result[i],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.download_sharp,
                                                        color: kcPrimary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: InvoiceViewer(
                                                  invoice: result[i],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 200),
                                        barrierDismissible: true,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                Container());
                                  },
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateFormat("dd/MM/yyyy")
                                              .format(result[i].date),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          result[i].reference,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "${result[i].total.toStringAsFixed(2)}€",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 5),
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
