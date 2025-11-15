import 'dart:convert';
import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  const Character({super.key, required this.personagem, this.onTap});
  final Map personagem;
  final VoidCallback? onTap;
  
  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 56,
        width: 56,
        color: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.grey),
      );
    }
    
    // Verifica se é base64 (data URI)
    if (imageUrl.startsWith('data:image')) {
      try {
        // Extrai a parte base64 (depois da vírgula)
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          height: 56,
          width: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 56,
              width: 56,
              color: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey),
            );
          },
        );
      } catch (e) {
        return Container(
          height: 56,
          width: 56,
          color: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey),
        );
      }
    } else {
      // É uma URL normal
      return Image.network(
        imageUrl,
        height: 56,
        width: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 56,
            width: 56,
            color: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.grey),
          );
        },
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            ClipOval(
              child: _buildImage(personagem["img"] ?? personagem["photoUrl"]),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personagem["personagem"] ?? personagem["name"] ?? 'Sem nome',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF0D0D0D),
                    ),
                  ),
                  Text(
                  personagem["companyName"] ?? personagem["nome"] ?? personagem["description"] ?? personagem["category"] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
