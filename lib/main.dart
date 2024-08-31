import 'package:condoview/providers/manutencao_provider.dart';
import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:condoview/screens/morador/signup/signup_screen.dart';
import 'package:condoview/services/secure_storege_service.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/providers/reserva_provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/screens/administrador/avisos/visualizar_avisos_screen.dart';
import 'package:condoview/screens/administrador/avisos/adicionar_avisos_screen.dart';
import 'package:condoview/screens/morador/home/home_screen.dart';
import 'package:condoview/screens/morador/conversas/chat_screen.dart';
import 'package:condoview/screens/morador/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => AvisoProvider()),
        ChangeNotifierProvider(create: (context) => ReservaProvider()),
        ChangeNotifierProvider(create: (_) => ManutencaoProvider()),
        ChangeNotifierProvider(create: (_) => OcorrenciaProvider()),
        Provider(create: (context) => SecureStorageService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioProvider>(
      builder: (context, usuarioProvider, child) {
        final isAuthenticated = usuarioProvider.usuario != null;

        return MaterialApp(
          title: 'CondoView',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          initialRoute: isAuthenticated ? '/home' : '/signup',
          routes: {
            '/home': (context) => const HomeScreen(),
            '/chat': (context) => const ChatScreen(name: 'Nome'),
            '/search': (context) => const SearchScreen(),
            '/visualizarAvisos': (context) => const VisualizarAvisosScreen(),
            '/adicionar': (context) => const AdicionarAvisoScreen(),
            '/signup': (context) => const SignupScreen(),
          },
        );
      },
    );
  }
}
