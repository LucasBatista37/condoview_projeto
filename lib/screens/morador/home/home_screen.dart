import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/components/custom_bottom_navigation_bar.dart';
import 'package:condoview/components/custom_drawer.dart';
import 'package:condoview/components/admin_grid.dart';
import 'package:condoview/components/menu_grid.dart';
import 'package:condoview/providers/usuario_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final userName = usuarioProvider.userName;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
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
      drawer: CustomDrawer(
        userName: userName,
        userEmail: usuarioProvider.usuario?.email ?? 'Email não disponível',
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
                      'Não haverá coleta de lixo na sexta-feira',
                      'De: Administração'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Administração',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const AdminGrid(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Menu Completo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const MenuGrid(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String from) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 2,
      child: ListTile(
        title: Text(title),
        subtitle: Text('$message\n$from'),
        isThreeLine: true,
      ),
    );
  }

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
}
