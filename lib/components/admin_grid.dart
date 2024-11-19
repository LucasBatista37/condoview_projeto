import 'package:condoview/screens/administrador/adicionarEncomenda/adicionar_encomenda_screen.dart';
import 'package:condoview/screens/administrador/aprovarEntrada/qr_code_scanner_screen.dart';
import 'package:condoview/screens/administrador/aprovarManutencao/visualizar_manutencao.dart';
import 'package:condoview/screens/administrador/aprovarReserva/visualizar_reservas_screen.dart';
import 'package:condoview/screens/administrador/avisos/visualizar_avisos_screen.dart';
import 'package:condoview/screens/administrador/criarAssembleia/lista_assembleias_screen.dart';
import 'package:condoview/screens/administrador/moradores/lista_moradores_screen.dart';
import 'package:condoview/screens/administrador/visualizarOcorrencia/lista_ocorrencias_screen.dart';
import 'package:flutter/material.dart';

class AdminGrid extends StatelessWidget {
  const AdminGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSection(
          context,
          'Adicionar',
          [
            _buildAdminItem(
              Icons.add_alert,
              'Aviso',
              const VisualizarAvisosScreen(),
              context,
            ),
            _buildAdminItem(
              Icons.mail,
              'Encomendas',
              const AdicionarEncomendaScreen(),
              context,
            ),
            _buildAdminItem(
              Icons.assignment,
              'Assembleia',
              const ListaAssembleiasScreen(),
              context,
            ),
          ],
        ),
        _buildSection(
          context,
          'Aprovar',
          [
            _buildAdminItem(
              Icons.check_circle,
              'Reserva',
              VisualizarReservasScreen(),
              context,
            ),
            _buildAdminItem(
              Icons.build,
              'Manutenção',
              const VisualizarManutencoesScreen(),
              context,
            ),
            _buildAdminItem(
              Icons.qr_code_scanner,
              'Entrada',
              QRCodeScannerScreen(),
              context,
            ),
          ],
        ),
        _buildSection(
          context,
          'Visualizar',
          [
            _buildAdminItem(
              Icons.visibility,
              'Ocorrências',
              const ListaOcorrenciasScreen(),
              context,
            ),
            _buildAdminItem(
              Icons.groups,
              'Moradores',
              const ListaMoradoresScreen(),
              context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> items) {
    final isScrollable = items.length > 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        isScrollable
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 12.0),
                            child: items[index],
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 0),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              )
            : GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: items,
              ),
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
