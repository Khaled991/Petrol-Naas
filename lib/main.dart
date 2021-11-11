import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petrol_naas/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:petrol_naas/mobx/customers/customers.dart';
import 'package:dio/dio.dart';
import 'widget/splash_screen/splash_screen.dart';
import 'mobx/added_items_to_new_invoice/added_items_to_new_invoice.dart';
import 'constants.dart';
import 'mobx/items/items.dart';
import 'mobx/user/user.dart';

void main() {
  // runApp(MotorController());
  runApp(MyApp());
}

class MotorController extends StatefulWidget {
  const MotorController({Key? key}) : super(key: key);

  @override
  _MotorControllerState createState() => _MotorControllerState();
}

BaseOptions dioOptions = BaseOptions(
  baseUrl: 'http://192.168.43.138:3000/',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

class _MotorControllerState extends State<MotorController> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petrol Naas',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Motor Controller"),
        ),
        body: Column(
          children: [
            PowerControl(),
            SpeedControl(),
            DirectionControl(),
          ],
        ),
      ),
    );
  }
}

class PowerControl extends StatefulWidget {
  const PowerControl({
    Key? key,
  }) : super(key: key);

  @override
  State<PowerControl> createState() => _PowerControlState();
}

class _PowerControlState extends State<PowerControl> {
  final TextEditingController _speedValueController = TextEditingController();

  bool powerState = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            "Power",
            style: TextStyle(fontSize: 20.0),
          ),
          Center(
            child: TextButton(
              onPressed: _togglePower,
              child: Text(
                powerState ? "ON" : "OFF",
                style: TextStyle(
                  fontSize: 18.0,
                  color: powerState ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePower() {
    Dio(dioOptions).post("/power", data: {
      "power": powerState ? "on" : "off",
    }).then((_) => setState(() => powerState = !powerState));
  }
}

class SpeedControl extends StatefulWidget {
  SpeedControl({
    Key? key,
  }) : super(key: key);

  @override
  State<SpeedControl> createState() => _SpeedControlState();
}

class _SpeedControlState extends State<SpeedControl> {
  final TextEditingController _speedValueController = TextEditingController();

  double _currentSpeed = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            "Speed: $_currentSpeed%",
            style: TextStyle(fontSize: 20.0),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: _speedValueController,
          ),
          Center(
            child: TextButton(
              onPressed: _setSpeed,
              child: Text(
                "Set speed",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _speedUp,
              child: Text(
                "Speed up 10%",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _speedDown,
              child: Text(
                "Speed down 10%",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setSpeed([double? speed]) {
    if (speed == null && double.parse(_speedValueController.text) > 100.0) {
      return showSnackBar(context, "Speed Must be less than 100%");
    }
    Dio(dioOptions).post("/speed", data: {
      "speed": speed ?? _speedValueController.text,
    }).then((_) => setState(
        () => _currentSpeed = double.parse(_speedValueController.text)));
  }

  void _speedUp() {
    if (_currentSpeed > 90) {
      return _setSpeed(100);
    }
    Dio(dioOptions).post("/speed", data: {
      "speed": "+",
    }).then((_) => setState(() => _currentSpeed += 10));
  }

  void _speedDown() {
    if (_currentSpeed < 10) {
      return _setSpeed(0);
    }
    Dio(dioOptions).post("/speed", data: {
      "speed": "-",
    }).then((_) => setState(() => _currentSpeed -= 10));
  }
}

class DirectionControl extends StatefulWidget {
  DirectionControl({
    Key? key,
  }) : super(key: key);

  @override
  State<DirectionControl> createState() => _DirectionControlState();
}

class _DirectionControlState extends State<DirectionControl> {
  bool _isCCW = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Direction: ${getDirectionText()}",
            style: TextStyle(fontSize: 20.0),
          ),
          Center(
            child: TextButton(
              onPressed: _setCW,
              child: Text(
                "Clockwise",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _setCCW,
              child: Text(
                "Counter Clockwise",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _reverseDirection,
              child: Text(
                "Reverse Direction",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDirectionText() {
    return _isCCW ? "CCW" : "CW";
  }

  void _setCW() {
    Dio(dioOptions).post("/direction", data: {
      "direction": "cw",
    }).then((value) => setState(() => _isCCW = false));
  }

  void _setCCW() {
    Dio(dioOptions).post("/direction", data: {
      "direction": "ccw",
    }).then((value) => setState(() => _isCCW = true));
  }

  void _reverseDirection() {
    Dio(dioOptions).post("/direction", data: {
      "direction": "rev",
    }).then((value) => setState(() => _isCCW = !_isCCW));
  }
}

class MyApp extends StatelessWidget {
  final _userStore = UserStore();
  final _customersStore = CustomerStore();
  final _itemsStore = ItemsStore();
  final _addedItemsToNewInvoiceStore = AddedItemsToNewInvoiceStore();

  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserStore>(create: (_) => _userStore),
        Provider<CustomerStore>(create: (_) => _customersStore),
        Provider<ItemsStore>(create: (_) => _itemsStore),
        Provider<AddedItemsToNewInvoiceStore>(
            create: (_) => _addedItemsToNewInvoiceStore),
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
      ),
    );
  }
}
