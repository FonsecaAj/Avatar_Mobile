import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/mis_cursos_controller.dart';

class MisCursosScreen extends StatelessWidget {
  const MisCursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MisCursosController());

    // Cargar cursos al entrar
    controller.cargarCursos();

    return MainLayout(
      title: "Mis Cursos",
      currentIndex: 1,
      child: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cursos.isEmpty) {
          return const Center(
            child: Text(
              "No tienes cursos registrados.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.cursos.length,
          itemBuilder: (_, i) {
            final curso = controller.cursos[i];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  curso.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F496E),
                  ),
                ),
                subtitle: Text(
                  curso.codigoCurso,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
