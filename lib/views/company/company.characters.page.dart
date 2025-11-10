import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partyup/widgets/company.character.display.dart';
import 'package:partyup/widgets/title.field.dart';

class CompanyCharactersPage extends StatelessWidget {
  const CompanyCharactersPage({super.key});

  void novoPersonagem(BuildContext context) {
    Navigator.pushNamed(context, '/characterAdd');
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('characters')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const TitleField(title: 'Personagens'),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, s) {
                  if (s.hasError)
                    return Center(child: Text('Erro: ${s.error}'));
                  if (!s.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = s.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text('Nenhum personagem'));
                  }

                  final characters = docs.map((d) {
                    final x = d.data();
                    return {
                      'id': d.id,
                      'nome': x['name'] ?? '',
                      'categoria': x['category'] ?? '',
                      'imagem': x['photoUrl'] ?? '',
                      'descricao': x['description'] ?? '',
                    };
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: characters.length,
                    itemBuilder: (context, i) =>
                        CompanyCharacterDisplay(character: characters[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => novoPersonagem(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
