import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tylunch/global/color.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/widget.dart';
import 'package:tylunch/model/orderhistory.dart';

class InvoiceViewer extends StatefulWidget {
  const InvoiceViewer({super.key, required this.invoice});
  final OrderHistoryModel invoice;
  @override
  State<InvoiceViewer> createState() => _InvoiceViewerState();
}

class _InvoiceViewerState extends State<InvoiceViewer> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: size.height * .6),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Date:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat("dd/MM/yyyy").format(widget.invoice.date),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Fracture:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.invoice.reference,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Entreprise:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    loggedUser!.company.name,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Nom:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${loggedUser!.name} ${loggedUser!.lastname}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomWidget().divider(num: 6),
            const SizedBox(height: 10),
            ...widget.invoice.items.map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.product?.dishName ?? e.formula!.name,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${e.unitprice.toStringAsFixed(2)}€",
                              style: const TextStyle(
                                color: kcPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "x${e.qty}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${e.amount.toStringAsFixed(2)}€",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: kcPrimary,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sous Total",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("${widget.invoice.subtotal.toStringAsFixed(2)}€"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "TVA",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("${widget.invoice.vat.toStringAsFixed(2)}€"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${widget.invoice.total.toStringAsFixed(2)}€",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kcPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
