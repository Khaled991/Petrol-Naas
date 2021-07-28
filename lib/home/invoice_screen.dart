import 'package:flutter/material.dart';
import 'package:petrol_naas/components/invoice_header.dart';
import 'package:petrol_naas/components/invoice_list_style.dart';
import 'package:petrol_naas/data/invoice_data.dart';
import 'package:petrol_naas/models/invoice.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  // late List<Invoice> invoices;

  @override
  void initState() {
    // invoices = fakeInvoices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InvoiceHeader(),
        Expanded(
          child: ListView(
            children: [
              InvoiceList(
                tittle: 'محمد الخرمان',
                billNumber: '1456452',
                date: '12-2-2022',
                onTap: () {},
              ),
              InvoiceList(
                tittle: 'محمد الخرمان',
                billNumber: '1456452',
                date: '12-2-2022',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
