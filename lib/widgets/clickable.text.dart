import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({
    super.key,
    required this.onTap,
    required this.secondaryText,
    required this.mainText,
  });
  final GestureTapCallback onTap;
  final String secondaryText;
  final String mainText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          secondaryText,
          style: const TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            mainText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
