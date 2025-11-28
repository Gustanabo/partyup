import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.ctrl,
    required this.fieldName,
    required this.fieldHint,
    this.icon,
    required this.numero,
    required this.obscure,
  });
  final TextEditingController ctrl;
  final String fieldName;
  final String fieldHint;
  final IconData? icon;
  final bool obscure;
  final bool numero;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            fieldName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!numero)
          TextField(
            decoration: InputDecoration(
              hintText: fieldHint,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
            controller: ctrl,
            obscureText: obscure,
          ),
        if (numero)
          IntlPhoneField(
            decoration: InputDecoration(
              hintText: fieldHint,
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
            initialCountryCode: 'BR',
            onChanged: (phone) {},
            controller: ctrl,
          ),
      ],
    );
  }
}
