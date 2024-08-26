import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/providers/reserva_provider.dart'; // Exemplo adicional
import 'package:condoview/screens/administrador/avisos/visualizar_avisos_screen.dart';
import 'package:condoview/screens/administrador/avisos/adicionar_avisos_screen.dart';
import 'package:condoview/screens/morador/home/home_screen.dart';
import 'package:condoview/screens/morador/conversas/chat_screen.dart';
import 'package:condoview/screens/morador/search/search_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AvisoProvider()),
        ChangeNotifierProvider(
            create: (context) => ReservaProvider()), // Exemplo adicional
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CondoView',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(name: 'Nome'),
        '/search': (context) => const SearchScreen(),
        '/visualizarAvisos': (context) => const VisualizarAvisosScreen(),
        '/adicionar': (context) => const AdicionarAvisoScreen(),
      },
    );
  }
}
