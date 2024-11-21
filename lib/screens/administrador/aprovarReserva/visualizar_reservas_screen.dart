import 'package:condoview/components/custom_empty.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/reserva_provider.dart';
import 'package:condoview/screens/administrador/aprovarReserva/aprovar_reserva_screen.dart';

class VisualizarReservasScreen extends StatefulWidget {
  const VisualizarReservasScreen({super.key});

  @override
  _VisualizarReservasScreenState createState() =>
      _VisualizarReservasScreenState();
}

class _VisualizarReservasScreenState extends State<VisualizarReservasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reservaProvider =
          Provider.of<ReservaProvider>(context, listen: false);
      reservaProvider.fetchReservas();
      reservaProvider.startPolling();
    });
  }

  @override
  void dispose() {
    final reservaProvider =
        Provider.of<ReservaProvider>(context, listen: false);
    reservaProvider.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservaProvider = Provider.of<ReservaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        foregroundColor: Colors.white,
        title: const Text(
          'Reservas Pendentes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reservas Pendentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: reservaProvider.reservas.isEmpty
                  ? const CustomEmpty(text: "Nenhuma reserva pendente.")
                  : ListView.builder(
                      itemCount: reservaProvider.reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservaProvider.reservas[index];
                        return _buildReservaCard(
                          context,
                          icon: Icons.event,
                          title: reserva.area,
                          date:
                              '${reserva.data.day}/${reserva.data.month}/${reserva.data.year} das ${reserva.horarioInicio.format(context)} às ${reserva.horarioFim.format(context)}',
                          status: reserva.status,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AprovarReservaScreen(
                                  reserva: reserva,
                                  reservaIndex: index,
                                ),
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

  Widget _buildReservaCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String date,
      required String status,
      required VoidCallback onTap}) {
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
            color: status == 'Aprovada'
                ? Colors.green
                : status == 'Pendente'
                    ? Colors.orange
                    : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
