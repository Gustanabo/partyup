// lib/views/client/client.requests.page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:partyup/widgets/title.field.dart';

class ClientRequestsPage extends StatelessWidget {
  const ClientRequestsPage({super.key});

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.grey, size: 30),
      );
    }
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return CircleAvatar(radius: 30, backgroundImage: MemoryImage(bytes));
      } catch (_) {
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey, size: 30),
        );
      }
    }
    return CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl));
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
      case 'scheduled':
        return Colors.green;
      case 'declined':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    final stream = FirebaseFirestore.instance
        .collection('requests')
        .where('clientId', isEqualTo: user.uid)
        .snapshots();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            const TitleField(title: 'Início'),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: stream,
                builder: (context, s) {
                  if (s.hasError) {
                    return const Center(child: Text('Erro ao carregar'));
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
                    return const Center(
                      child: Text('Você ainda não fez solicitações'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final x = docs[i].data();
                      final status = (x['status'] as String?) ?? 'pending';
                      final dateText = (x['dateText'] as String?) ?? '';
                      final startTime = (x['startTime'] as String?) ?? '';
                      final endTime = (x['endTime'] as String?) ?? '';
                      final characterName =
                          (x['characterName'] as String?) ?? 'Personagem';
                      final photo = (x['characterPhotoUrl'] as String?) ?? '';
                      final address = (x['address'] as String?) ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildImage(photo),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        characterName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        address.isNotEmpty
                                            ? address
                                            : 'Local não informado',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${dateText.isNotEmpty ? dateText : 'Data a definir'} ${startTime.isNotEmpty && endTime.isNotEmpty ? '$startTime - $endTime' : ''}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  status == 'pending'
                                      ? 'Pendente'
                                      : status == 'accepted'
                                      ? 'Aceito'
                                      : status == 'declined'
                                      ? 'Recusado'
                                      : status,
                                  style: TextStyle(
                                    color: _statusColor(status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
