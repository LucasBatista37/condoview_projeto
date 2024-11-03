import 'package:condoview/components/custom_button.dart';
import 'package:condoview/components/custom_empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/reserva_provider.dart';
import 'package:condoview/screens/morador/reservas/solicitar_reserva.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservaProvider =
        Provider.of<ReservaProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Reservas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: reservaProvider.fetchReservas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar reservas.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Áreas Disponíveis para Reserva',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Consumer<ReservaProvider>(
                      builder: (context, reservaProvider, _) {
                        if (reservaProvider.reservas.isEmpty) {
                          return const CustomEmpty(
                            text: "Nenhuma reserva registrada.",
                          );
                        }
                        return ListView.builder(
                          itemCount: reservaProvider.reservas.length,
                          itemBuilder: (context, index) {
                            final reserva = reservaProvider.reservas[index];
                            return _buildReservaCard(
                              context,
                              icon: Icons.event,
                              title: reserva.area,
                              date:
                                  '${reserva.data.day}/${reserva.data.month}/${reserva.data.year} das ${reserva.horarioInicio.hour.toString().padLeft(2, '0')}:${reserva.horarioInicio.minute.toString().padLeft(2, '0')} às ${reserva.horarioFim.hour.toString().padLeft(2, '0')}:${reserva.horarioFim.minute.toString().padLeft(2, '0')}',
                              status: reserva.status,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: "Solicitar Reserva",
                    icon: Icons.add,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SolicitarReserva(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildReservaCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String date,
      required String status}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 78, 20, 166)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(date),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Aprovada' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
