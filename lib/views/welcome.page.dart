import 'package:flutter/material.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/title.field.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/party_icon.png',
            ),
            const TitleField(
                title: 'Encontre o personagem perfeito para a sua festa!'),
            Button(
              text: 'Começar',
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
            )
          ],
        ),
      ),
    );
  }
}
