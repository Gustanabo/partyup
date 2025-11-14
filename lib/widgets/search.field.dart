import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController ctrl;

  final ValueChanged<String>? onSubmitted;

  const SearchField({super.key, required this.ctrl, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      decoration: const InputDecoration(
        hintText: 'Buscar personagem...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
    );
  }
}
