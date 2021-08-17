import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:petrol_naas/widget/print_invoice.dart';

import 'components/custom_dropdown.dart';
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
        // home: ScaffoldDropDown(),
        home: SplashScreen(),
      ),
    );
  }
}

// class Model {
//   late int id;
//   late String name;

//   Model({required this.id, required this.name});

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'name': name,
//       };
// }

// class ScaffoldDropDown extends StatefulWidget {
//   ScaffoldDropDown({Key? key}) : super(key: key);

//   @override
//   State<ScaffoldDropDown> createState() => _ScaffoldDropDownState();
// }

// class _ScaffoldDropDownState extends State<ScaffoldDropDown> {
//   final List<Model> _testList = <Model>[
//     Model(id: 1, name: "One"),
//     Model(id: 2, name: "Two"),
//     Model(id: 3, name: "Three"),
//   ];

//   Model? _selectedValue;

//   resetDropDown() {
//     setState(() {
//       _selectedValue = null;
//     });
//   }

//   void setDropDown(value) => setState(() => _selectedValue = value);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("DropDown"),
//       ),
//       body: Column(
//         children: [
//           CustomDropdown(
//             items: _testList,
//             textProperty: 'name',
//             label: 'Test',
//             selectedValue: _selectedValue,
//             onChanged: setDropDown,
//           ),
//           TextButton(onPressed: resetDropDown, child: Text('delete'))
//         ],
//       ),
//     );
//   }
// }
