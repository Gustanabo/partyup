import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/profile.field.dart';
import 'package:partyup/widgets/profile.section.dart';
import 'package:partyup/widgets/title.field.dart';

class CompanyProfilePage extends StatelessWidget {
  CompanyProfilePage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void deslogar(BuildContext context) async {
    await _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Center(child: Text('Não autenticado'));
    }

    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // doc com o mesmo UID do auth
        .snapshots();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, s) {
        if (s.hasError) return Center(child: Text('Erro: ${s.error}'));
        if (s.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = s.data?.data() ?? {};
        final nomeEmpresa = (data['name'] ?? user.displayName ?? '—') as String;
        final cnpj = (data['cnpj'] ?? '—') as String;
        final email = (data['email'] ?? user.email ?? '—') as String;
        final numero = (data['numero'] ?? '—') as String;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TitleField(title: 'Perfil'),
                const SizedBox(height: 24),
                Text(
                  nomeEmpresa,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const ProfileSection(title: 'Meus Dados'),
                ProfileField(
                  title: 'Nome da Empresa',
                  subtitle: nomeEmpresa,
                  icon: Icons.business,
                ),
                ProfileField(title: 'CNPJ', subtitle: cnpj, icon: Icons.badge),
                ProfileField(
                  title: 'E-mail',
                  subtitle: email,
                  icon: Icons.mail,
                ),
                ProfileField(
                  title: 'Telefone',
                  subtitle: numero,
                  icon: Icons.phone,
                ),
                const SizedBox(height: 24),
                Button(
                  text: 'Sair',
                  onPressed: () => deslogar(context),
                  textColor: Colors.red,
                  icon: const Icon(Icons.logout, color: Colors.red),
                  backgroundColor: Colors.redAccent.withOpacity(0.08),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
