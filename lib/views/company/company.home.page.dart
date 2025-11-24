import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partyup/views/company/company.appointments.page.dart';
import 'package:partyup/views/company/company.characters.page.dart';
import 'package:partyup/views/company/company.profile.page.dart';
import 'package:partyup/views/company/company.request.page.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  CompanyHomePageState createState() => CompanyHomePageState();
}

class CompanyHomePageState extends State<CompanyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User? user = _auth.currentUser;

  int selectedIndex = 0;

  void navigationChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  late final List<Widget> pages = [
    CompanyAppointmentsPage(),
    CompanyRequestPage(),
    CompanyCharactersPage(),
    CompanyProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      body: SafeArea(top: false, bottom: true, child: pages[selectedIndex]),

      // Barra inferior
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: navigationChange,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Agendamentos",
          ),
          NavigationDestination(
            icon: Icon(Icons.note),
            label: "Solicitações",
          ),
          NavigationDestination(
            icon: Icon(Icons.face),
            label: "Personagens",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}
