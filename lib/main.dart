import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'components/splash_screen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      locale: Locale("ar", "AE"), // OR Locale('ar', 'AE') OR Other RTL locales,
      theme: ThemeData(
        fontFamily: "Changa",
        primaryColor: primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
