import 'package:condoview/screens/conversas/coversations_screen.dart';
import 'package:flutter/material.dart';
import 'package:condoview/screens/conversas/chat_screen.dart';
import 'package:condoview/screens/home/home_screen.dart';
import 'package:condoview/screens/search/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/conversas': (context) => const ConversationsScreen(),
        '/chat': (context) => const ChatScreen(name: 'Nome'),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
