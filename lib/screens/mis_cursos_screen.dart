import 'package:flutter/material.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

class MisCursosScreen extends StatelessWidget {
  const MisCursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Mis Cursos',
      currentIndex: 1,
      child: Center(
        child: Text('Contenido de Mis Cursos'),
      ),
    );
  }
}
