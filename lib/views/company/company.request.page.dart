import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:partyup/widgets/request.dart';
import 'package:partyup/widgets/title.field.dart';

class CompanyRequestPage extends StatelessWidget {
  const CompanyRequestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleField(title: 'Novas Solicitações'),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    return const Center(child: Text('Usuário não autenticado'));
                  }
                  final stream = FirebaseFirestore.instance
                      .collection('requests')
                      .where('companyId', isEqualTo: user.uid)
                      .snapshots();

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: stream,
                    builder: (context, s) {
                      if (s.hasError) {
                        return Center(
                          child: Text('Erro ao carregar solicitações'),
                        );
                      }
                      if (s.connectionState == ConnectionState.waiting ||
                          !s.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var docs = s.data!.docs.toList();
                      docs.sort((a, b) {
                        final ta = a.data()['createdAt'] as Timestamp?;
                        final tb = b.data()['createdAt'] as Timestamp?;
                        final da = ta?.toDate();
                        final db = tb?.toDate();
                        return (db?.millisecondsSinceEpoch ?? 0).compareTo(
                          da?.millisecondsSinceEpoch ?? 0,
                        );
                      });
                      if (docs.isEmpty) {
                        return const Center(child: Text('Nenhuma solicitação'));
                      }
                      docs = docs.where((doc) {
                        final status =
                            (doc.data()['status'] as String?) ?? 'pending';
                        return status == 'pending';
                      }).toList();
                      if (docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.inbox, size: 64, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'Nenhuma solicitação pendente',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, i) {
                          final d = docs[i];
                          final x = d.data();
                          final item = {
                            'id': d.id,
                            'nome': x['characterName'] ?? '',
                            'descricao': x['title'] ?? 'Pedido de agendamento',
                            'data':
                                '${x['dateText'] ?? ''} ${x['startTime'] ?? ''} - ${x['endTime'] ?? ''}',
                            'imagem': x['characterPhotoUrl'] ?? '',
                            'local': x['address'] ?? '',
                            'cliente': x['clientName'] ?? '',
                            'contato': x['phone'] ?? '',
                          };
                          return Request(
                            item: item,
                            onDecline: () async {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(d.id)
                                  .update({'status': 'declined'});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Solicitação recusada'),
                                ),
                              );
                            },
                            onAccept: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Solicitação aceita e adicionada aos agendamentos',
                                  ),
                                ),
                              );
                              final data = d.data();
                              await FirebaseFirestore.instance
                                  .collection('appointments')
                                  .add({
                                    'companyId': data['companyId'],
                                    'companyName': data['companyName'],
                                    'characterId': data['characterId'],
                                    'characterName': data['characterName'],
                                    'characterPhotoUrl':
                                        data['characterPhotoUrl'],
                                    'clientId': data['clientId'],
                                    'clientName': data['clientName'],
                                    'date': data['date'],
                                    'dateText': data['dateText'],
                                    'startTime': data['startTime'],
                                    'endTime': data['endTime'],
                                    'address': data['address'],
                                    'notes': data['notes'],
                                    'status': 'scheduled',
                                    'createdAt': FieldValue.serverTimestamp(),
                                    'contato': data['phone'],
                                  });
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(d.id)
                                  .update({'status': 'accepted'});
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
