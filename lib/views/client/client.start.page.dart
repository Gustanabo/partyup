import 'package:flutter/material.dart';
import 'package:partyup/widgets/category.dart';
import 'package:partyup/widgets/search.field.dart';
import 'package:partyup/widgets/title.field.dart';

class ClientStartPage extends StatelessWidget {
  ClientStartPage({super.key});
  final TextEditingController pesquisaCtrl = TextEditingController();
  final List<Map<String, String>> categorias = [
    {"titulo": "Princesas", "img": "assets/images/princesas.png"},
    {"titulo": "Super-Heróis", "img": "assets/images/super_herois.png"},
    {"titulo": "Desenhos", "img": "assets/images/desenhos.png"},
    {"titulo": "Palhaços", "img": "assets/images/palhaços.png"},
    {"titulo": "Animais", "img": "assets/images/animais.png"},
    {"titulo": "Halloween", "img": "assets/images/halloween.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleField(title: 'Início'),
            const SizedBox(height: 16),
            SearchField(
              ctrl: pesquisaCtrl,
            ),
            const SizedBox(height: 24),
            const Text(
              "Categorias",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1423),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: GridView.builder(
                    itemCount: categorias.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) =>
                        Category(category: categorias[index]))),
          ],
        ),
      ),
    );
  }
}
