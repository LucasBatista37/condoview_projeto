// screens/conversations_screen.dart
import 'package:flutter/material.dart';
import 'package:condoview/screens/morador/conversas/chat_screen.dart';
import 'package:condoview/components/custom_bottom_navigation_bar.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  int _currentIndex = 4;

  // Lista de nomes fictícios
  final List<String> _names = [
    'Pedro Lopes',
    'Nicholas',
    'Adryan Alexander',
    'Lucas',
    'Edkarllos'
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      switch (_currentIndex) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/procurar');
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
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Conversas',
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
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus Vizinhos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _names.map((name) {
                  final firstLetter =
                      name.isNotEmpty ? name[0].toUpperCase() : '';

                  return Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Últimas Conversas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _names.length,
                    itemBuilder: (context, index) {
                      final name = _names[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        title: Text(
                          name,
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Última mensagem...',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              '12:00 PM',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(name: name),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
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
}
