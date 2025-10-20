import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  int selectedIndex = 0;

  void navigationChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    Column(
      children: [
        TextField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
        ),
        Text(
          'Categorias',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Expanded(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: List.generate(
                6,
                (index) {
                  return Container(
                    child: Column(
                      children: [
                        Placeholder(
                          fallbackHeight: 150,
                        ),
                        Text('Categoria $index')
                      ],
                    ),
                  );
                },
              )),
        )
      ],
    ),
    Column(
      children: [
        TextField(
          decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(),
                title: Text('Resultado $index'),
                subtitle: Text('Empresa $index'),
              );
            },
          ),
        ),
      ],
    ),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 181, 192),
        title: Text('Cliente'),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: navigationChange,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Buscar",
          )
        ],
      ),
    );
  }
}
