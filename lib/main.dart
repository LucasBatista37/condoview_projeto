import 'package:condoview/screens/administrador/adicionar_avisos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/aviso_provider.dart';
import 'screens/home/home_screen.dart';
import 'screens/conversas/chat_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/avisos/avisos_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AvisoProvider(),
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
        '/avisos': (context) => const AvisosScreen(),
        '/adicionar': (context) => const AdicionarAvisoScreen(),
      },
    );
  }
}
