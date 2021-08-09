import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobx/mobx.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/widget/print_invoice.dart';
import 'package:provider/provider.dart';
import 'components/splash_screen.dart';
import 'constants.dart';
import 'mobx/items/items.dart';
import 'mobx/my_invoice/my_invoices.dart';
import 'mobx/user/user.dart';

void main() {
  // ignore: avoid_print
  mainContext.spy(print);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _userStore = UserStore();
  final _customersStore = CustomerStore();
  final _itemsStore = ItemsStore();
  final _myInvoices = MyInvoices();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserStore>(create: (_) => _userStore),
        Provider<CustomerStore>(create: (_) => _customersStore),
        Provider<ItemsStore>(create: (_) => _itemsStore),
        Provider<MyInvoices>(create: (_) => _myInvoices),
      ],
      child: MaterialApp(
        title: 'Petrol Naas',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales
        ],
        locale:
            Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales,
        theme: ThemeData(
          fontFamily: "Changa",
          primaryColor: primaryColor,
        ),
        // home: PrintInvoice(),
        home: SplashScreen(),
      ),
    );
  }
}
