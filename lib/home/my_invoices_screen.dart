import 'package:flutter/material.dart';
import 'package:petrol_naas/components/invoice_header.dart';
import 'package:petrol_naas/components/invoice_list_style.dart';

import 'invoice_screen.dart';

class MyInvoicesScreen extends StatefulWidget {
  const MyInvoicesScreen({Key? key}) : super(key: key);

  @override
  State<MyInvoicesScreen> createState() => _MyInvoicesScreenState();
}

class _MyInvoicesScreenState extends State<MyInvoicesScreen> {
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
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InvoiceScreen(
                        finalPrice: 1627.25,
                      ),
                    ),
                  ),
                },
              ),
              InvoiceList(
                tittle: 'محمد الخرمان',
                billNumber: '1456452',
                date: '12-2-2022',
                onTap: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InvoiceScreen(
                        finalPrice: 1627.25,
                      ),
                    ),
                  ),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
