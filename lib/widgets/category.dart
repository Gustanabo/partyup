import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({super.key, required this.category});
  final Map category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/characterDetails");
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              category["img"]!,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category["titulo"]!,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1423),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
