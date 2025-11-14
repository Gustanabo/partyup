import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final Map<String, String> category;

  final VoidCallback? onTap;

  const Category({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              category['img']!,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['titulo']!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
