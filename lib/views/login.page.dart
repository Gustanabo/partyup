import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Encontre o personagem perfeito para sua festa!", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                SizedBox(height:20),
                Text("Escolha seu perfil para começar")
              ]
            ),

            SizedBox(height: 20),
            Column(children: [
              ElevatedButton(onPressed: () => {}, child: Text("Sou um cliente")),
              SizedBox(height: 10),
              ElevatedButton(onPressed: () => {}, child: Text("Sou uma empresa"))
            ],)
          ],
        ),
      )
    );
  }
}