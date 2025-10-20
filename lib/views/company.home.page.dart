import 'package:flutter/material.dart';

class CompanyHomePage extends StatefulWidget {
  @override
  CompanyHomePageState createState() => CompanyHomePageState();
}

class CompanyHomePageState extends State<CompanyHomePage> {
  int selectedIndex = 0;

  void navigationChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    Center(child: Text("Agenda")),
    Center(child: Text("Solicitações")),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 181, 192),
        title: Text('Empresa'),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: navigationChange,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Agenda",
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            label: "Solicitações",
          )
        ],
      ),
    );
  }
}
