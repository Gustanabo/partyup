import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/profile.field.dart';
import 'package:partyup/widgets/profile.section.dart';

class CompanyProfilePage extends StatelessWidget {
  CompanyProfilePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  void deslogar(BuildContext context) {
    _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Empresa Teste',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          // Seção: Meus Dados
          const ProfileSection(title: 'Meus Dados'),
          ProfileField(
            title: 'Nome da Empresa',
            subtitle: 'Empresa teste',
            icon: Icons.person,
          ),
          ProfileField(
            title: 'CNPJ',
            subtitle: '00.000.000/0000-00',
            icon: Icons.person,
          ),
          ProfileField(
            title: 'E-mail',
            subtitle: 'E-mail teste',
            icon: Icons.mail,
          ),

          const ProfileSection(title: 'Serviços'),
          const ProfileField(
            title: 'Histórico de Serviços',
            icon: Icons.history,
          ),
          const SizedBox(height: 24),
          Button(
              text: 'Sair',
              onPressed: () => deslogar(context),
              textColor: Colors.red,
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              backgroundColor: Colors.red.shade50),
        ],
      ),
    );
  }
}
