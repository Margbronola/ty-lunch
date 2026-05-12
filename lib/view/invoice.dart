import 'package:flutter/material.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/orderhistory.dart';
import 'package:tylunch/viewmodel/orderhistory.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final OrderHistoryViewModel _viewModel = OrderHistoryViewModel.instance;

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
              Image.asset(
                'assets/icons/circ1.png',
                fit: BoxFit.fitWidth,
                width: double.maxFinite,
              ),
              StreamBuilder<List<OrderHistoryModel>>(
                stream: _viewModel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError) {
                    if (snapshot.data!.isNotEmpty) {
                      final List<OrderHistoryModel> result = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.check_circle_rounded,
                                color: kcPrimary,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Order Successfully Sent",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (_, i) {
                              return Container(
                                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                                  // color: Colors.black26,
                                  // child: Column(
                                  //   children: [
                                  //     Text(result[i].reference)
                                  //   ],
                                  // ),
                                  );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 20),
                            itemCount: result.length,
                          )
                        ],
                      );
                    }
                  }
                  return CustomWidget().loader();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
