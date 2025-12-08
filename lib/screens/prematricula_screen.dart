import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/prematricula_controller.dart';

class PrematriculaScreen extends StatelessWidget {
  const PrematriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrematriculaController());
    controller.cargarPrematricula();

    return MainLayout(
      title: "Prematrícula",
      currentIndex: 1,
      child: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.prematriculas.isEmpty) {
          return const Center(
            child: Text(
              "No hay prematrículas registradas.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.prematriculas.length,
          itemBuilder: (_, i) {
            final p = controller.prematriculas[i];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  "${p.nombreCurso} (${p.codigoCurso})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text("Carrera: ${p.nombreCarrera}"),
                    Text("Periodo: ${p.numeroPeriodo} - ${p.anio}"),
                    Text("Notas: ${p.observaciones}"),
                    Text("Inicio: ${p.fechaInicio.split('T')[0]}"),
                    Text("Fin: ${p.fechaFin.split('T')[0]}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
