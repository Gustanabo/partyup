import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientLoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController senhaCtrl = TextEditingController();

  void logar(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailCtrl.text, password: senhaCtrl.text);
      Navigator.pushNamed(context, "/clientHome");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Erro ao logar.')));
    }
  }

  void registrar(BuildContext context) {
    Navigator.pushNamed(context, "/registro");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            const Text(
              "Bem-vindo de volta!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C1B1F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Acesse sua conta para continuar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            // Campo de e-mail
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "E-mail",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: "Digite seu e-mail",
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              controller: emailCtrl,
            ),

            const SizedBox(height: 16),

            // Campo de senha
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Senha",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Digite sua senha",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              controller: senhaCtrl,
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ainda não tem uma conta? ",
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/clientRegister");
                  },
                  child: const Text(
                    "Cadastre-se",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => logar(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
