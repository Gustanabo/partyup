import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:partyup/widgets/appointment.dart';
import 'package:partyup/widgets/title.field.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:partyup/views/company/company.appointments.details.page.dart';

class CompanyAppointmentsPage extends StatefulWidget {
  const CompanyAppointmentsPage({super.key});

  @override
  State<CompanyAppointmentsPage> createState() => _CompanyAppointmentsPageState();
}

class _CompanyAppointmentsPageState extends State<CompanyAppointmentsPage> {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const TitleField(title: 'Agendamentos'),
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => selectedDay != null && isSameDay(day, selectedDay),
            onDaySelected: (sel, foc) => setState(() { selectedDay = sel; focusedDay = foc; }),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Agendamentos para o dia ${selectedDay?.day ?? DateTime.now().day}/${selectedDay?.month ?? DateTime.now().month}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Builder(
              builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return const Center(child: Text('Usuário não autenticado'));
                }
                final stream = FirebaseFirestore.instance
                    .collection('appointments')
                    .where('companyId', isEqualTo: user.uid)
                    .snapshots();
                final dayToShow = selectedDay ?? DateTime.now();

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: stream,
                  builder: (context, s) {
                    if (s.hasError) {
                      return const Center(child: Text('Erro ao carregar agendamentos'));
                    }
                    if (s.connectionState == ConnectionState.waiting || !s.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var docs = s.data!.docs.where((d) {
                      final ts = d.data()['date'] as Timestamp?;
                      final dt = ts?.toDate();
                      return dt != null && dt.year == dayToShow.year && dt.month == dayToShow.month && dt.day == dayToShow.day;
                    }).toList();
                    docs.sort((a, b) {
                      final ta = a.data()['startTime'] as String?;
                      final tb = b.data()['startTime'] as String?;
                      return (ta ?? '').compareTo(tb ?? '');
                    });
                    if (docs.isEmpty) {
                      return const Center(child: Text('Nenhum agendamento para o dia selecionado'));
                    }
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final x = docs[i].data();
                        return Appointment(
                          nome: x['characterName'] ?? 'Agendamento',
                          horario: '${x['dateText'] ?? ''} ${x['startTime'] ?? ''} - ${x['endTime'] ?? ''}',
                          icone: '🎉',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CompanyAppointmentDetailsPage(
                                  appointmentId: docs[i].id,
                                  data: x,
                                ),
                              ),
                            );
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
    );
  }
}
