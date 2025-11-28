import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class CharacterDetailsPage extends StatefulWidget {
  const CharacterDetailsPage({super.key, this.character});
  final Map? character;

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  String? selectedStartTime;
  String? selectedEndTime;
  DateTime? selectedDay;
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  final List<String> horas = List.generate(
    14,
    (i) => '${(10 + i).toString().padLeft(2, '0')}:00',
  );

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 360,
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
          child: Image.memory(
            bytes,
            height: 360,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        return Container(
          height: 360,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: Colors.grey, size: 48),
        );
      }
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          height: 360,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.character?["name"] ??
              widget.character?["personagem"] ??
              'Personagem'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildImage(
                widget.character?["photoUrl"] ?? widget.character?["img"],
              ),
              const SizedBox(height: 12),
              Text(
                (((widget.character?["companyName"] as String?)?.isNotEmpty ??
                        false)
                    ? 'Empresa: ${widget.character?["companyName"] as String}'
                    : ''),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Descrição",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (widget.character?["description"] ??
                    'Não há descrição para este personagem.'),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "Data Desejada",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TableCalendar(
                  headerStyle: HeaderStyle(formatButtonVisible: false),
                  availableGestures: AvailableGestures.horizontalSwipe,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  selectedDayPredicate: (day) =>
                      selectedDay != null && isSameDay(day, selectedDay),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Horário de entrada',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffd9de),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStartTime,
                        hint: const Text(
                          'Selecione o horário de entrada',
                          style: TextStyle(color: Colors.black),
                        ),
                        items: horas
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedStartTime = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Horário de saída',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffd9de),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedEndTime,
                        hint: const Text(
                          'Selecione o horário de saída',
                          style: TextStyle(color: Colors.black),
                        ),
                        items: horas
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedEndTime = value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Local da festa",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: addressCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Digite o endereço",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Notas adicionais",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: notesCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Algum pedido especial?",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
              ),

              //_buildTextField("Additional Notes", "Any special requests?", maxLines: 3),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: const Text(
                    "Solicitar Agendamento",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (selectedDay == null ||
        selectedStartTime == null ||
        selectedEndTime == null ||
        addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione data, horários de entrada/saída e informe o endereço',
          ),
        ),
      );
      return;
    }
    // valida ordem
    int _toMinutes(String t) {
      final p = t.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    }

    final startMin = _toMinutes(selectedStartTime!);
    final endMin = _toMinutes(selectedEndTime!);
    if (endMin <= startMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Horário de saída deve ser após o horário de entrada'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado')));
      return;
    }

    try {
      final companyId = widget.character?['companyId'] as String? ?? '';
      final characterId = widget.character?['id'] as String? ?? '';
      final dayTs = Timestamp.fromDate(
        DateTime(selectedDay!.year, selectedDay!.month, selectedDay!.day),
      );
      // checa conflitos: busca todos os agendamentos do personagem e filtra por dia
      final qs = await FirebaseFirestore.instance
          .collection('appointments')
          .where('characterId', isEqualTo: characterId)
          .get();
      final sameDay = qs.docs.where((d) {
        final ts = d.data()['date'] as Timestamp?;
        final dt = ts?.toDate();
        return dt != null &&
            dt.year == selectedDay!.year &&
            dt.month == selectedDay!.month &&
            dt.day == selectedDay!.day;
      });
      bool conflict = false;
      for (final d in sameDay) {
        final x = d.data();
        final s = x['startTime'] as String?;
        final e = x['endTime'] as String?;
        if (s != null && e != null) {
          final sm = _toMinutes(s);
          final em = _toMinutes(e);
          if (startMin < em && endMin > sm) {
            conflict = true;
            break;
          }
        }
      }
      if (conflict) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Horário indisponível para este personagem'),
          ),
        );
        return;
      }

      final clientDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final clientName =
          user.displayName ?? (clientDoc.data()?['name'] as String?) ?? '';
      final companyName = widget.character?['companyName'] as String? ?? '';
      final characterName =
          widget.character?['name'] as String? ??
          widget.character?['personagem'] as String? ??
          '';
      final characterPhotoUrl =
          widget.character?['photoUrl'] as String? ??
          widget.character?['img'] as String? ??
          '';
      final dateText =
          '${selectedDay!.day.toString().padLeft(2, '0')}/${selectedDay!.month.toString().padLeft(2, '0')}/${selectedDay!.year}';
      final phone = (clientDoc.data()?['numero'] as String);

      await FirebaseFirestore.instance.collection('requests').add({
        'companyId': companyId,
        'companyName': companyName,
        'characterId': characterId,
        'characterName': characterName,
        'characterPhotoUrl': characterPhotoUrl,
        'clientId': user.uid,
        'clientName': clientName,
        'date': dayTs,
        'dateText': dateText,
        'startTime': selectedStartTime,
        'endTime': selectedEndTime,
        'address': addressCtrl.text.trim(),
        'notes': notesCtrl.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'phone': phone,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Solicitação enviada!')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao enviar solicitação: $e')));
    }
  }

  @override
  void dispose() {
    addressCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }
}
