import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partyup/views/character/character.add.page.dart';
import 'package:partyup/views/character/character.details.page.dart';
import 'package:partyup/views/client/client.home.page.dart';
import 'package:partyup/views/client/client.login.page.dart';
import 'package:partyup/views/client/client.register.page.dart';
import 'package:partyup/views/company/company.login.page.dart';
import 'package:partyup/views/company/company.register.page.dart';
import 'views/welcome.page.dart';
import 'views/company/company.home.page.dart';

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyAjV5oCiLCgaIsVQRDrIwAuziwR8RHh9IY",
    authDomain: "partyup-92422.firebaseapp.com",
    projectId: "partyup-92422",
    storageBucket: "partyup-92422.firebasestorage.app",
    messagingSenderId: "465457911757",
    appId: "1:465457911757:web:fba127715ef3742d149684");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
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
