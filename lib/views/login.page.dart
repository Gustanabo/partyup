import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/clickable.text.dart';
import 'package:partyup/widgets/input.field.dart';
import 'package:partyup/widgets/title.field.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController senhaCtrl = TextEditingController();
  bool isLoading = false;

  void logar(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      await _auth.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: senhaCtrl.text,
      );
      final user = _auth.currentUser;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() => isLoading = false);
      if (doc['empresa'] == 1) {
        Navigator.pushNamed(context, '/companyHome');
      } else {
        Navigator.pushNamed(context, '/clientHome');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Erro ao logar.')));
    }
  }

  void registrar(BuildContext context) {
    Navigator.pushNamed(context, "/register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Column(
                children: [
                  TitleField(title: 'Bem-vindo de volta!'),
                  SizedBox(height: 8),
                  Text("Acesse sua conta para continuar"),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  // Campo de e-mail
                  InputField(
                    ctrl: emailCtrl,
                    fieldName: 'E-mail',
                    fieldHint: 'Digite seu e-mail',
                    icon: Icons.person_outline,
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  // Campo de senha
                  InputField(
                    ctrl: senhaCtrl,
                    fieldName: 'Senha',
                    fieldHint: 'Digite sua senha',
                    icon: Icons.lock,
                    obscure: true,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Button(text: 'Entrar', onPressed: () => logar(context)),
                  const SizedBox(height: 8),
                  ClickableText(
                    onTap: () => registrar(context),
                    secondaryText: 'Ainda não tem uma conta? ',
                    mainText: 'Cadastre-se',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
