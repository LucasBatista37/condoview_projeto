// custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
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
        onTap(index); // Notifica o controlador sobre o índice selecionado
      },
      backgroundColor: Colors.grey[200], // Cor de fundo da barra
      selectedItemColor: const Color.fromARGB(
          255, 78, 20, 166), // Cor roxa para o item selecionado
      unselectedItemColor:
          Colors.black54, // Cor preta para itens não selecionados
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Procurar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Condomínio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_city),
          label: 'Vizinhança',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Conversas',
        ),
      ],
    );
  }
}
