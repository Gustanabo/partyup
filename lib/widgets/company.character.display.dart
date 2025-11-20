import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:partyup/views/character/character.edit.page.dart';

class CompanyCharacterDisplay extends StatelessWidget {
  const CompanyCharacterDisplay({super.key, required this.character});
  final Map character;

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: 35,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.grey, size: 35),
      );
    }
    
    // Verifica se é base64 (data URI)
    if (imageUrl.startsWith('data:image')) {
      try {
        // Extrai a parte base64 (depois da vírgula)
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return CircleAvatar(
          radius: 35,
          backgroundImage: MemoryImage(bytes),
          onBackgroundImageError: (exception, stackTrace) {
            // Se houver erro, não faz nada (já tem fallback)
          },
        );
      } catch (e) {
        return CircleAvatar(
          radius: 35,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey, size: 35),
        );
      }
    } else {
      // É uma URL normal
      return CircleAvatar(
        radius: 35,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (exception, stackTrace) {
          // Se houver erro, não faz nada (já tem fallback)
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildImage(character['imagem']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character['nome']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  character['categoria']!,
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
              final id = character['id'] as String?;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CharacterEditPage(
                    characterId: id ?? '',
                    initialData: {
                      'name': character['nome'],
                      'category': character['categoria'],
                      'description': character['descricao'],
                      'photoUrl': character['imagem'],
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit,
                color: Color.fromARGB(255, 255, 181, 192)),
          ),
        ],
      ),
    );
  }
}
