import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partyup/views/client/client.profile.page.dart';
import 'package:partyup/views/client/client.search.page.dart';
import 'package:partyup/views/client/client.start.page.dart';

class ClientHomePage extends StatefulWidget {
  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void deslogar(BuildContext context) {
    _auth.signOut();
    Navigator.pop(context);
  }

  int selectedIndex = 0;

  void navigationChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  late final List<Widget> pages = [
    ClientStartPage(),
    ClientSearchPage(), // Página de busca sem filtros iniciais
    ClientProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      body: pages[selectedIndex],

      // Barra inferior
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: navigationChange,
        backgroundColor: Colors.white,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Buscar",
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
