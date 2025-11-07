import 'package:flutter/material.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/company.character.display.dart';

class CompanyCharactersPage extends StatelessWidget {
  CompanyCharactersPage({super.key});
  void novoPersonagem(BuildContext context) {
    Navigator.pushNamed(context, '/characterAdd');
  }

  final List characters = [
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Button(
              text: 'Novo Personagem',
              onPressed: () => novoPersonagem(context)),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final item = characters[index];
                return CompanyCharacterDisplay(
                  character: item,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
