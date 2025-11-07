import 'package:flutter/material.dart';
import 'package:partyup/widgets/appointment.dart';
import 'package:table_calendar/table_calendar.dart';

class CompanyAppointmentsPage extends StatelessWidget {
  CompanyAppointmentsPage({super.key});

  final Map<DateTime, List<Map<String, String>>> agendamentos = {
    DateTime(2024, 7, 5): [
      {
        'titulo': 'Festa de Aniversário',
        'horario': '10:00 - 11:00',
        'icone': '🎂'
      },
      {
        'titulo': 'Evento Corporativo',
        'horario': '14:00 - 15:00',
        'icone': '💼'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Agendamentos para o dia ${DateTime.now().day} de ${DateTime.now().month}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: agendamentos[DateTime(2024, 7, 5)]?.length ?? 0,
              itemBuilder: (context, index) => Appointment(
                  nome: agendamentos[DateTime(2024, 7, 5)]![index]['titulo']!,
                  horario: agendamentos[DateTime(2024, 7, 5)]![index]
                      ['horario']!,
                  icone: agendamentos[DateTime(2024, 7, 5)]![index]['icone']!),
            ),
          ),
        ],
      ),
    );
  }
}
