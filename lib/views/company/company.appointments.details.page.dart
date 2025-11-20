import 'dart:convert';
import 'package:flutter/material.dart';

class CompanyAppointmentDetailsPage extends StatelessWidget {
  const CompanyAppointmentDetailsPage({
    super.key,
    required this.appointmentId,
    required this.data,
  });

  final String appointmentId;
  final Map<String, dynamic> data;

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.person, color: Colors.grey, size: 48),
      );
    }
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(bytes, height: 160, width: double.infinity, fit: BoxFit.cover),
        );
      } catch (_) {
        return Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: Colors.grey, size: 48),
        );
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterName = (data['characterName'] as String?) ?? 'Personagem';
    final clientName = (data['clientName'] as String?) ?? '';
    final dateText = (data['dateText'] as String?) ?? '';
    final startTime = (data['startTime'] as String?) ?? '';
    final endTime = (data['endTime'] as String?) ?? '';
    final address = (data['address'] as String?) ?? '';
    final notes = (data['notes'] as String?) ?? '';
    final status = (data['status'] as String?) ?? 'scheduled';
    final photo = (data['characterPhotoUrl'] as String?) ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        title: const Text(
          'Detalhes do Agendamento',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(photo),
            const SizedBox(height: 16),
            Text(
              characterName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            const Text('Cliente', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(clientName.isNotEmpty ? clientName : '—', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            const Text('Data e Horários', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              '${dateText.isNotEmpty ? dateText : '—'} ${startTime.isNotEmpty && endTime.isNotEmpty ? '$startTime - $endTime' : ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text('Local da Festa', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(address.isNotEmpty ? address : '—', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            const Text('Notas', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(notes.isNotEmpty ? notes : '—', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            const Text('Status', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'accepted':
      case 'scheduled':
        return Colors.green;
      case 'declined':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'accepted':
        return 'Aceito';
      case 'scheduled':
        return 'Agendado';
      case 'declined':
        return 'Recusado';
      case 'pending':
      default:
        return 'Pendente';
    }
  }
}