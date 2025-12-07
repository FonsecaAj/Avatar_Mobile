import 'package:flutter/material.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

class MatriculaScreen extends StatelessWidget {
  const MatriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Matrícula',
      currentIndex: 2,
      child: Center(
        child: Text('Contenido de Matrícula'),
      ),
    );
  }
}
