import 'package:flutter/material.dart';
import 'package:partyup/widgets/character.dart';
import 'package:partyup/widgets/title.field.dart';

class ClientSearchPage extends StatefulWidget {
  const ClientSearchPage({super.key});

  @override
  State<ClientSearchPage> createState() => _ClientSearchPageState();
}

class _ClientSearchPageState extends State<ClientSearchPage> {
  final personagens = [
    {
      "nome": "Lucas",
      "personagem": "Homem-Aranha",
      "img": "assets/images/spiderman.jpg",
    },
    {
      "nome": "Ana",
      "personagem": "Minnie",
      "img": "assets/images/minnie.jpg",
    },
    {
      "nome": "Pedro",
      "personagem": "Batman",
      "img": "assets/images/batman.jpg",
    },
    {
      "nome": "Sofia",
      "personagem": "Elsa",
      "img": "assets/images/elsa.jpg",
    },
    {
      "nome": "Gabriel",
      "personagem": "Capitão América",
      "img": "assets/images/cap.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            const TitleField(title: 'Resultados da busca'),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: personagens.length,
                itemBuilder: (context, index) =>
                    Character(personagem: personagens[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
