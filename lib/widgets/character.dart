import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  const Character({super.key, required this.personagem});
  final Map personagem;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              personagem["img"] ?? personagem["photoUrl"] ?? '',
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
            ),
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
                  personagem["nome"] ?? personagem["description"] ?? personagem["category"] ?? '',
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
    );
  }
}
