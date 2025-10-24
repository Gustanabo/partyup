import 'package:flutter/material.dart';
import 'package:partyup/views/character.add.page.dart';
import 'package:partyup/views/character.details.page.dart';
import 'package:partyup/views/client.home.page.dart';
import 'package:partyup/views/client.login.page.dart';
import 'package:partyup/views/client.register.page.dart';
import 'package:partyup/views/company.login.page.dart';
import 'package:partyup/views/company.register.page.dart';
import 'views/welcome.page.dart';
import 'views/company.home.page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 255, 181, 192))),
      debugShowCheckedModeBanner: false,
      routes: {
        "/welcome": (context) => WelcomePage(),
        "/companyLogin": (context) => CompanyLoginPage(),
        "/companyRegister": (context) => CompanyRegisterPage(),
        "/companyHome": (context) => CompanyHomePage(),
        "/clientHome": (context) => ClientHomePage(),
        "/clientLogin": (context) => ClientLoginPage(),
        "/clientRegister": (context) => ClientRegisterPage(),
        "/characterDetails": (context) => CharacterDetailsPage(),
        "/characterAdd": (context) => CharacterAddPage()
      },
      initialRoute: "/welcome",
    );
  }
}
