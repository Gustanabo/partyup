import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partyup/widgets/button.dart';
import 'package:partyup/widgets/clickable.text.dart';
import 'package:partyup/widgets/input.field.dart';
import 'package:partyup/widgets/title.field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController cnpjCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController senhaCtrl = TextEditingController();
  final TextEditingController senhaConfCtrl = TextEditingController();
  bool empresa = false;
  void logar(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  void registrar(BuildContext context) async {
    try {
      var company = await _auth.createUserWithEmailAndPassword(
          email: emailCtrl.text, password: senhaCtrl.text);
      await company.user!.updateDisplayName(nomeCtrl.text);

      final User? user = company.user;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference users = firestore.collection('users');
        if (empresa) {
          await users.doc(user.uid).set({
            'name': nomeCtrl.text,
            'email': emailCtrl.text,
            'cnpj': cnpjCtrl.text,
            'empresa': 1
          });
          Navigator.pushReplacementNamed(context, "/companyHome");
        } else {
          await users.doc(user.uid).set({
            'name': nomeCtrl.text,
            'email': emailCtrl.text,
            'empresa': 0,
          });
          Navigator.pushReplacementNamed(context, "/clientHome");
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Erro ao registrar.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              children: [
                TitleField(title: 'Crie sua conta!'),
                SizedBox(height: 8),
                Text("Preencha os campos abaixo para começar."),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: empresa,
                        onChanged: (value) => setState(() {
                          empresa = value!;
                        }),
                      ),
                      const Text('Registrar como empresa'),
                      const SizedBox(height: 16)
                    ],
                  ),
                  InputField(
                    ctrl: nomeCtrl,
                    fieldName: empresa ? 'Nome da Empresa' : 'Nome Completo',
                    fieldHint: empresa
                        ? 'Digite o nome da sua empresa'
                        : 'Digite seu nome completo',
                    obscure: false,
                  ),
                  const SizedBox(height: 16),
                  if (empresa)
                    InputField(
                      ctrl: cnpjCtrl,
                      fieldName: 'CNPJ (Opcional)',
                      fieldHint: 'Deixe vazio se for autônomo',
                      obscure: false,
                    ),
                  if (empresa) const SizedBox(height: 16),
                  InputField(
                      ctrl: emailCtrl,
                      fieldName: 'E-mail',
                      fieldHint: 'Digite seu e-mail',
                      obscure: false),
                  const SizedBox(height: 16),
                  InputField(
                      ctrl: senhaCtrl,
                      fieldName: 'Crie uma senha',
                      fieldHint: 'Digite uma senha para sua conta',
                      obscure: true),
                  const SizedBox(height: 16),
                  InputField(
                      ctrl: senhaConfCtrl,
                      fieldName: 'Confirme sua senha',
                      fieldHint: 'Digite sua senha mais uma vez',
                      obscure: true),
                  const SizedBox(height: 8),
                ],
              ),
            ), // Botão Registrar
            Column(
              children: [
                Button(
                  text: 'Registrar',
                  onPressed: () => registrar(context),
                ),
                const SizedBox(height: 8),
                ClickableText(
                    onTap: () => logar(context),
                    secondaryText: 'Já tem uma conta? ',
                    mainText: 'Faça Login'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
