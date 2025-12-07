import 'package:flutter/material.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

class PrematriculaScreen extends StatelessWidget {
  const PrematriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Prematrícula',
      currentIndex: -1, // No corresponde a ningún tab del bottom nav
      child: Center(
        child: Text('Contenido de Prematrícula'),
      ),
    );
  }
}
