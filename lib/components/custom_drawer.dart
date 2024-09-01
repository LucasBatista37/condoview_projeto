import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:condoview/providers/usuario_provider.dart';
import 'package:condoview/screens/morador/editarPerfil/editar_perfil_screen.dart';
import 'package:condoview/screens/morador/login/login_screen.dart';
import 'package:condoview/screens/morador/settings/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UsuarioProvider>(
      builder: (context, usuarioProvider, child) {
        final userName = usuarioProvider.userName;
        final userEmail = usuarioProvider.usuario?.email ?? '';
        final profileImageUrl = usuarioProvider.userProfileImage;

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 78, 20, 166),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: _getProfileImage(profileImageUrl),
                      radius: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        userEmail,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditarPerfilScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sair'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ImageProvider _getProfileImage(String? profileImageUrl) {
    if (profileImageUrl == null || profileImageUrl.isEmpty) {
      return const AssetImage('assets/images/perfil.jpg');
    } else if (File(profileImageUrl).existsSync()) {
      return FileImage(File(profileImageUrl));
    } else if (Uri.tryParse(profileImageUrl)?.hasAbsolutePath ?? false) {
      return NetworkImage(profileImageUrl);
    } else {
      return const AssetImage('assets/images/perfil.jpg');
    }
  }
}
