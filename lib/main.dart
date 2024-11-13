import 'package:condoview/providers/assembleia_provider.dart';
import 'package:condoview/providers/chat_provider.dart';
import 'package:condoview/providers/encomenda_provider.dart';
import 'package:condoview/providers/manutencao_provider.dart';
import 'package:condoview/providers/ocorrencia_provider.dart';
import 'package:condoview/providers/personal_chat_provider.dart';
import 'package:condoview/screens/administrador/createCondo/create_condo_screen.dart';
import 'package:condoview/screens/morador/chat/chat_geral_screen.dart';
import 'package:condoview/screens/morador/condominio/condominio_screen.dart';
import 'package:condoview/screens/morador/conversas/coversations_screen.dart';
import 'package:condoview/screens/morador/signup/signup_screen.dart';
import 'package:condoview/services/secure_storege_service.dart';
import 'package:condoview/providers/aviso_provider.dart';
import 'package:condoview/providers/reserva_provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:condoview/providers/condominium_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/screens/administrador/avisos/adicionar_avisos_screen.dart';
import 'package:condoview/screens/morador/home/home_screen.dart';
import 'package:condoview/screens/morador/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => AvisoProvider()),
        ChangeNotifierProvider(create: (context) => ReservaProvider()),
        ChangeNotifierProvider(create: (context) => ManutencaoProvider()),
        ChangeNotifierProvider(create: (context) => OcorrenciaProvider()),
        ChangeNotifierProvider(create: (context) => EncomendasProvider()),
        ChangeNotifierProvider(create: (context) => AssembleiaProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => CondoProvider()),
        ChangeNotifierProvider(create: (context) => PersonalChatProvider()),
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
          debugShowCheckedModeBanner: false,
          title: 'CondoView',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          initialRoute: isAuthenticated ? '/home' : '/signup',
          routes: {
            '/home': (context) => const HomeScreen(),
            '/search': (context) => const SearchScreen(),
            '/adicionar': (context) => const AdicionarAvisoScreen(),
            '/signup': (context) => const SignupScreen(),
            '/conversas': (context) => const ConversationsScreen(),
            '/condominio': (context) => const CondominioScreen(),
            '/create_condo': (context) => const CreateCondoScreen(),
            '/chat_geral': (context) => const ChatGeralScreen(),
          },
        );
      },
    );
  }
}
