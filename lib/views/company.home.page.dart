import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CompanyHomePage extends StatefulWidget {
  @override
  CompanyHomePageState createState() => CompanyHomePageState();
}

class CompanyHomePageState extends State<CompanyHomePage> {
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

  final Map<DateTime, List<Map<String, String>>> agendamentos = {
    DateTime(2024, 7, 5): [
      {
        'titulo': 'Festa de Aniversário',
        'horario': '10:00 - 11:00',
        'icone': '🎂'
      },
      {
        'titulo': 'Evento Corporativo',
        'horario': '14:00 - 15:00',
        'icone': '💼'
      },
    ],
  };
  final solicitacoes = [
    {
      'nome': 'Elsa',
      'descricao': 'Festa de aniversário',
      'data': '24 de Outubro, 2025 às 14:00 - 15:00',
      'imagem': 'assets/images/elsa.jpg', // substitua pelas suas imagens locais
    },
    {
      'nome': 'Homem-Aranha',
      'descricao': 'Festa de aniversário',
      'data': '28 de Outubro, 2025 às 16:00 - 17:00',
      'imagem': 'assets/images/spiderman.jpg',
    },
    {
      'nome': 'Minnie Mouse',
      'descricao': 'Festa de aniversário',
      'data': '02 de Outubro, 2025 às 11:00 - 12:00',
      'imagem': 'assets/images/minnie.jpg',
    },
  ];
  final personagens = [
    {
      'nome': 'Elsa',
      'categoria': 'Princesa',
      'imagem': 'assets/images/elsa.jpg',
    },
    {
      'nome': 'Homem-Aranha',
      'categoria': 'Super-herói',
      'imagem': 'assets/images/spiderman.jpg',
    },
    {
      'nome': 'Minnie Mouse',
      'categoria': 'Desenho animado',
      'imagem': 'assets/images/minnie.jpg',
    },
    {
      'nome': 'Batman',
      'categoria': 'Super-herói',
      'imagem': 'assets/images/batman.jpg',
    },
  ];

  late final List<Widget> pages = [
    Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Agendamentos para o dia ${DateTime.now().day} de ${DateTime.now().month}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '📅',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Festa 1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '10:00 - 11:00',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '📅',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Festa 2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '16:00 - 17:00',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.grey, size: 16),
              ],
            ),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Novas solicitações',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: solicitacoes.length,
              itemBuilder: (context, index) {
                final item = solicitacoes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(item['imagem']!),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nome']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  item['descricao']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  item['data']!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFffd9de),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Recusar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFffd9de),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Aceitar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/characterAdd");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
              ),
              child: const Text(
                "Novo Personagem",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: personagens.length,
              itemBuilder: (context, index) {
                final item = personagens[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(item['imagem']!),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['nome']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              item['categoria']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // ação: editar personagem futuramente
                        },
                        icon: const Icon(Icons.edit,
                            color: Color.fromARGB(255, 255, 181, 192)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Empresa Teste',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),

          // Seção: Meus Dados
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Meus Dados',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person,
                      color: Color.fromARGB(255, 255, 181, 192), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome da Empresa',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Empresa Teste',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person,
                      color: Color.fromARGB(255, 255, 181, 192), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CNPJ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '00.000.000/0000-00',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mail,
                      color: Color.fromARGB(255, 255, 181, 192), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-mail',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'email@teste',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Serviços',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffd9de),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.history,
                      color: Color.fromARGB(255, 255, 181, 192), size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Histórico de Serviços',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => deslogar(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 6),
                  Text(
                    "Sair",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
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
