import 'package:condoview/screens/administrador/adicionarEncomenda/adicionar_encomenda_screen.dart';
import 'package:condoview/screens/administrador/adicionarMorador/adicionar_morador_screen.dart';
import 'package:condoview/screens/administrador/aprovarManutencao/visualizar_manutencao.dart';
import 'package:condoview/screens/administrador/aprovarReserva/visualizar_reservas_screen.dart';
import 'package:condoview/screens/administrador/avisos/visualizar_avisos_screen.dart';
import 'package:condoview/screens/administrador/criarAssembleia/lista_assembleias_screen.dart';
import 'package:condoview/screens/administrador/visualizarOcorrencia/lista_ocorrencias_screen.dart';
import 'package:condoview/screens/morador/construcao/contrucao_screen.dart';
import 'package:flutter/material.dart';

class AdminGrid extends StatelessWidget {
  const AdminGrid({super.key});

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
        _buildAdminItem(Icons.person_add, 'Adicionar Morador',
            const AdicionarMoradorScreen(), context),
        _buildAdminItem(Icons.add_alert, 'Adicionar Aviso',
            const VisualizarAvisosScreen(), context),
        _buildAdminItem(
            Icons.check_circle,
            'Aprovar Reservas',
            const VisualizarReservasScreen(
              reservas: [],
            ),
            context),
        _buildAdminItem(Icons.build, 'Aprovar Manutenção',
            const VisualizarManutencoesScreen(), context),
        _buildAdminItem(Icons.assessment, 'Gerar Relatório',
            const EmConstrucaoScreen(), context),
        _buildAdminItem(Icons.assignment, 'Criar Assembleia',
            const ListaAssembleiasScreen(), context),
        _buildAdminItem(Icons.mail, 'Adicionar Correspondência',
            const AdicionarEncomendaScreen(), context),
        _buildAdminItem(Icons.block, 'Inativar Usuário',
            const EmConstrucaoScreen(), context),
        _buildAdminItem(Icons.visibility, 'Visualizar Ocorrências',
            const ListaOcorrenciasScreen(), context),
      ],
    );
  }

  Widget _buildAdminItem(
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
          border: Border.all(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 8),
            Flexible(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
