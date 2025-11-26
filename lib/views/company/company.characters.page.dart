import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:partyup/widgets/company.character.display.dart';
import 'package:partyup/widgets/title.field.dart';

class CompanyCharactersPage extends StatelessWidget {
  const CompanyCharactersPage({super.key});

  void novoPersonagem(BuildContext context) {
    Navigator.pushNamed(context, '/characterAdd');
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Map<String, dynamic> character,
  ) async {
    final name = character['nome'] as String? ?? 'personagem';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir personagem'),
        content: Text('Tem certeza que deseja excluir "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _deleteCharacter(context, character);
    }
  }

  Future<void> _deleteCharacter(
    BuildContext context,
    Map<String, dynamic> character,
  ) async {
    final id = character['id'] as String?;
    final imageUrl = character['imagem'] as String? ?? '';
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID do personagem inválido.')),
      );
      return;
    }
    try {
      // Exclui documento no Firestore
      await FirebaseFirestore.instance
          .collection('characters')
          .doc(id)
          .delete();

      // Tenta excluir imagem do Storage se for URL válida (não base64)
      if (imageUrl.isNotEmpty && !imageUrl.startsWith('data:image')) {
        try {
          final ref = firebase_storage.FirebaseStorage.instance.refFromURL(
            imageUrl,
          );
          await ref.delete();
        } on firebase_storage.FirebaseException catch (e) {
          // Permite seguir mesmo se não conseguir apagar a imagem
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Documento excluído. Imagem não removida (${e.code}).',
              ),
            ),
          );
        } catch (_) {
          // Ignora outros erros silenciosamente
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Personagem excluído.')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado')),
      );
    }

    // Filtra personagens apenas da empresa logada
    final stream = FirebaseFirestore.instance
        .collection('characters')
        .where('companyId', isEqualTo: user.uid)
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
                  if (s.hasError) {
                    final error = s.error;
                    print('Erro no StreamBuilder: $error');
                    print('Tipo do erro: ${error.runtimeType}');

                    // Verifica se é erro de índice do Firestore
                    final errorString = error.toString();
                    if (errorString.contains('index') ||
                        errorString.contains('Index')) {
                      print('ERRO DE ÍNDICE DO FIRESTORE DETECTADO!');
                      print('Mensagem completa: $error');

                      // Tenta extrair o link do índice
                      if (errorString.contains('https://')) {
                        final linkStart = errorString.indexOf('https://');
                        final linkEnd = errorString.indexOf(' ', linkStart);
                        if (linkEnd != -1) {
                          final link = errorString.substring(
                            linkStart,
                            linkEnd,
                          );
                          print('LINK PARA CRIAR ÍNDICE: $link');
                        } else {
                          final link = errorString.substring(linkStart);
                          print('LINK PARA CRIAR ÍNDICE: $link');
                        }
                      }
                    }

                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar personagens',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Erro: $error',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Verifique o console para mais detalhes.\n'
                              'Se for erro de índice, use o link fornecido para criar o índice no Firestore.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (s.connectionState == ConnectionState.waiting ||
                      !s.hasData) {
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
                    itemBuilder: (context, i) {
                      final c = characters[i];
                      return CompanyCharacterDisplay(
                        character: c,
                        onDelete: () => _confirmDelete(context, c),
                      );
                    },
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
