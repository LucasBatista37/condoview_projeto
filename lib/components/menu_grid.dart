import 'package:condoview/screens/morador/avisos/avisos_screen.dart';
import 'package:flutter/material.dart';
import 'package:condoview/screens/morador/assembleias/assembleias_screen.dart';
import 'package:condoview/screens/morador/depesas/expenses_screen.dart';
import 'package:condoview/screens/morador/encomendas/encomendas_screen.dart';
import 'package:condoview/screens/morador/manutencao/manutencao_screen.dart';
import 'package:condoview/screens/morador/ocorrencia/ocorrencia_screen.dart';
import 'package:condoview/screens/morador/reservas/reservas_screen.dart';
import 'package:condoview/screens/morador/visitante/visitante_screen.dart';
import 'package:condoview/screens/morador/chat/chat_geral_screen.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuItem(
            Icons.person, 'Visitante', const VisitanteScreen(), context),
        _buildMenuItem(Icons.warning, 'Avisos', const AvisosScreen(), context),
        _buildMenuItem(Icons.local_shipping, 'Encomendas',
            const EncomendasScreen(), context),
        _buildMenuItem(Icons.meeting_room, 'Assembleias',
            const AssembleiasScreen(), context),
        _buildMenuItem(
            Icons.calendar_today, 'Reservas', const ReservasScreen(), context),
        _buildMenuItem(
            Icons.build, 'Manutenção', const ManutencaoScreen(), context),
        _buildMenuItem(Icons.create_rounded, 'Ocorrências',
            const OcorrenciaScreen(), context),
        _buildMenuItem(Icons.chat, 'Chat Geral', const ChatGeralScreen(), context),
        _buildMenuItem(Icons.account_balance_wallet, 'Despesas',
            const DespesasScreen(), context),
      ],
    );
  }

  Widget _buildMenuItem(
      IconData icon, String label, Widget screen, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border:
              Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
