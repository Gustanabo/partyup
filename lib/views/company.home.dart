import 'package:flutter/material.dart';

class CompanyHome extends StatefulWidget {

  @override
  CompanyHomeState createState() => CompanyHomeState();
}

class CompanyHomeState extends State<CompanyHome> {
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