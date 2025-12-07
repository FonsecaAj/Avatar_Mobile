import 'package:flutter/material.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

class PagosScreen extends StatelessWidget {
  const PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Pagos',
      currentIndex: 3,
      child: Center(
        child: Text('Contenido de Pagos'),
      ),
    );
  }
}
