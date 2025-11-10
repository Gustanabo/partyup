import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.ctrl});
  final TextEditingController ctrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFffd9de),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Buscar personagens",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        controller: ctrl,
      ),
    );
  }
}
