import 'package:condoview/providers/reserva_provider.dart';
import 'package:flutter/material.dart';
import 'package:condoview/models/reserva_model.dart';
import 'package:provider/provider.dart';

class AprovarReservaScreen extends StatefulWidget {
  final Reserva reserva;
  final int reservaIndex;

  const AprovarReservaScreen({
    Key? key,
    required this.reserva,
    required this.reservaIndex,
  }) : super(key: key);

  @override
  _AprovarReservaScreenState createState() => _AprovarReservaScreenState();
}

class _AprovarReservaScreenState extends State<AprovarReservaScreen> {
  bool _isLoading = false;

  @override
  @override
  Widget build(BuildContext context) {
    final reserva = widget.reserva;

    debugPrint('ID da reserva: ${reserva.id}');
    debugPrint('Área solicitada: ${reserva.area}');
    debugPrint('Descrição: ${reserva.descricao}');
    debugPrint('Data: ${reserva.data}');
    debugPrint('Horário de Início: ${reserva.horarioInicio}');
    debugPrint('Horário de Fim: ${reserva.horarioFim}');
    debugPrint(
        'Nome do Usuário: ${reserva.nomeUsuario}');

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
          'Aprovar Reserva',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailContainer(
              label: 'Área Solicitada',
              value: reserva.area,
            ),
            _buildDetailContainer(
              label: 'Descrição',
              value: reserva.descricao,
            ),
            _buildDetailContainer(
              label: 'Data',
              value:
                  '${reserva.data.day}/${reserva.data.month}/${reserva.data.year}',
            ),
            _buildDetailContainer(
              label: 'Horário de Início',
              value:
                  '${reserva.horarioInicio.hour}:${reserva.horarioInicio.minute.toString().padLeft(2, '0')}',
            ),
            _buildDetailContainer(
              label: 'Horário de Fim',
              value:
                  '${reserva.horarioFim.hour}:${reserva.horarioFim.minute.toString().padLeft(2, '0')}',
            ),
            _buildDetailContainer(
              label: 'Nome do Usuário',
              value: reserva.nomeUsuario,
            ),
            const SizedBox(height: 16),
            _buildActionButtons(context),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : () => _handleAprovarReserva(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Aprovar Reserva',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed:
                _isLoading ? null : () => _handleRejeitarReserva(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: const Text(
              'Rejeitar Reserva',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAprovarReserva(BuildContext context) async {
    final provider = Provider.of<ReservaProvider>(context, listen: false);
    final reserva = widget.reserva;

    if (reserva.id != null) {
      setState(() => _isLoading = true);

      try {
        debugPrint('Aprovando reserva com ID: ${reserva.id}');
        await provider.aprovarReserva(reserva.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva aprovada com sucesso!')),
        );
        Navigator.pop(context);
      } catch (error) {
        debugPrint('Erro ao aprovar reserva: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao aprovar reserva.')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      debugPrint('Erro: ID da reserva é nulo.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID da reserva é nulo.')),
      );
    }
  }

  Future<void> _handleRejeitarReserva(BuildContext context) async {
    final provider = Provider.of<ReservaProvider>(context, listen: false);
    final reserva = widget.reserva;

    if (reserva.id != null) {
      setState(() => _isLoading = true);

      try {
        debugPrint('Rejeitando reserva com ID: ${reserva.id}');
        await provider.rejeitarReserva(reserva.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva rejeitada.')),
        );
        Navigator.pop(context);
      } catch (error) {
        debugPrint('Erro ao rejeitar reserva: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao rejeitar reserva.')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      debugPrint('Erro: ID da reserva é nulo.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID da reserva é nulo.')),
      );
    }
  }

  Widget _buildDetailContainer({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
        ),
      ],
    );
  }
}
