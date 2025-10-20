import 'package:flutter/material.dart';
import 'package:partyup/views/client.home.page.dart';
import 'views/login.page.dart';
import 'views/company.home.page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/welcome": (context) => WelcomePage(),
        "/company": (context) => CompanyHomePage(),
        "/client": (context) => ClientHomePage()
      },
      initialRoute: "/welcome",
    );
  }
}
