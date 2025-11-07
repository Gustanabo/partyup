import 'package:flutter/material.dart';
import 'package:partyup/widgets/request.dart';

class CompanyRequestPage extends StatelessWidget {
  CompanyRequestPage({super.key});
  final solicitacoes = [
    {
      'nome': 'Elsa',
      'descricao': 'Festa de aniversário',
      'data': '24 de Outubro, 2025 às 14:00 - 15:00',
      'imagem': 'assets/images/elsa.jpg',
    },
    {
      'nome': 'Homem-Aranha',
      'descricao': 'Festa de aniversário',
      'data': '28 de Outubro, 2025 às 16:00 - 17:00',
      'imagem': 'assets/images/spiderman.jpg',
    },
    {
      'nome': 'Minnie Mouse',
      'descricao': 'Festa de aniversário',
      'data': '02 de Outubro, 2025 às 11:00 - 12:00',
      'imagem': 'assets/images/minnie.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Novas solicitações',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: solicitacoes.length,
              itemBuilder: (context, index) {
                final item = solicitacoes[index];
                return Request(
                  item: item,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
