import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobx/mobx.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:provider/provider.dart';
import 'components/splash_screen.dart';
import 'constants.dart';
import 'mobx/items/items.dart';
import 'mobx/user/user.dart';
import 'models/invoice_item.dart';

void main() {
  mainContext.spy(print);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _userStore = UserStore();
  final _customersStore = CustomerStore();
  final _itemsStore = ItemsStore();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserStore>(create: (_) => _userStore),
        Provider<CustomerStore>(create: (_) => _customersStore),
        Provider<ItemsStore>(create: (_) => _itemsStore),
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
        home: SplashScreen(),
        //  CounterTest(),
      ),
    );
  }
}

// class CounterTest extends StatelessWidget {
//   CounterTest({Key? key}) : super(key: key);
//   // final CounterStore _counter = CounterStore();
//   TextEditingController countController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final store = context.watch<CounterStore>();

//     return Scaffold(
//       body: SafeArea(
//         child: Observer(builder: (_) {
//           return Column(
//             children: [
//               Text(store.counter.toString()),
//               Btn(),
//               TextButton(
//                   onPressed: () => store.setCounter(store.counter - 1),
//                   child: Text("-")),
//               TextField(
//                 controller: countController,
//               ),
//               TextButton(
//                 onPressed: () =>
//                     store.setCounter(int.parse(countController.text)),
//                 child: Text("set"),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => CounterChangedTest(),
//                   ),
//                 ),
//                 child: Text("test"),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

// class Btn extends StatefulWidget {
//   const Btn({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<Btn> createState() => _BtnState();
// }

// class _BtnState extends State<Btn> {
//   _onTap() {
//     final store = context.read<CounterStore>();
//     store.setCounter(store.counter + 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(onPressed: _onTap, child: Text("+"));
//   }
// }

// class CounterChangedTest extends StatelessWidget {
//   const CounterChangedTest({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final store = Provider.of<CounterStore>(context);
//     return Text(store.counter.toString());
//   }
// }
