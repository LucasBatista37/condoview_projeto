import 'package:flutter/material.dart';
import 'package:condoview/components/custom_bottom_navigation_bar.dart';
import 'package:condoview/components/custom_drawer.dart'; // Importando o novo componente
import 'package:condoview/screens/assembleias/assembleias_screen.dart';
import 'package:condoview/screens/avisos/avisos_screen.dart';
import 'package:condoview/screens/depesas/expenses_screen.dart';
import 'package:condoview/screens/encomendas/encomendas_screen.dart';
import 'package:condoview/screens/manutencao/manutencao_screen.dart';
import 'package:condoview/screens/ocorrencia/ocorrencia_screen.dart';
import 'package:condoview/screens/reservas/reservas_screen.dart';
import 'package:condoview/screens/visitante/visitante_screen.dart';
import 'package:condoview/screens/chat/chat_geral_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (_currentIndex) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/condominio');
        break;
      case 3:
        Navigator.pushNamed(context, '/vizinhança');
        break;
      case 4:
        Navigator.pushNamed(context, '/conversas');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 20, 166),
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/user.jpeg'),
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lucas',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Condomínio Fictício',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(136, 255, 255, 255),
              ),
            ),
          ],
        ),
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      drawer: const CustomDrawer(
        userName: 'Lucas',
        userEmail: 'Lucas@gmail.com',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vinda, Ana você tem três novas notificações!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildNotificationCard('Conversas', 'Oi Ana!', 'De: Mario'),
                  _buildNotificationCard(
                      'Manutenção',
                      'Manutenção da piscina dia 25 de julho das 8h às 12h',
                      'De: João'),
                  _buildNotificationCard(
                      'Avisos',
                      'Não haverá coleta de lixo no feriado de 15 de agosto!',
                      'De: João'),
                  const SizedBox(height: 32),
                  const Text(
                    'Menu completo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildMenuGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String sender) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(message),
        trailing: Text(sender),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuItem(Icons.person, 'Visitante', const VisitanteScreen()),
        _buildMenuItem(Icons.notifications, 'Avisos', const AvisosScreen()),
        _buildMenuItem(
            Icons.calendar_today, 'Reservas', const ReservasScreen()),
        _buildMenuItem(Icons.build, 'Manutenção', const ManutencaoScreen()),
        _buildMenuItem(Icons.attach_money, 'Despesas', const DespesasScreen()),
        _buildMenuItem(Icons.chat, 'Chat', const ChatGeralScreen()),
        _buildMenuItem(
            Icons.assignment, 'Assembleia', const AssembleiasScreen()),
        _buildMenuItem(
            Icons.local_shipping, 'Encomenda', const EncomendasScreen()),
        _buildMenuItem(Icons.warning, 'Ocorrências', const OcorrenciaScreen()),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, Widget screen) {
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
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
