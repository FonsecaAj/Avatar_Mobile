import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/matricula_controller.dart';
import 'package:modulo_mobil/screens/matricula_nueva_screen.dart';

class MatriculaScreen extends StatelessWidget {
  const MatriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador
    final controller = Get.put(MatriculaController());

    // Formato de fecha para mostrar
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');

    return MainLayout(
      title: "Matrícula Actual",
      currentIndex: 2, // pestaña Matrícula en el bottom nav
      child: Obx(() {
        // -------- Estado de carga --------
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // -------- Estado sin datos --------
        if (controller.matriculaList.isEmpty) {
          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "No hay cursos matriculados o la consulta falló.\nIntente de nuevo más tarde.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Matricularme'),
                  onPressed: () async {
                    final result = await Get.to<bool>(
                      () => const MatriculaNuevaScreen(),
                    );
                    if (result == true) {
                      await controller.cargarMatricula();
                    }
                  },
                ),
              ),
            ],
          );
        }

        // -------- Datos cargados: agrupados por período --------
        final matriculaPorPeriodo = controller.matriculaPorPeriodo;
        final periodos = matriculaPorPeriodo.keys.toList();

        return Stack(
          children: [
            // Lista de matrículas con padding abajo para que no tape el botón
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: periodos.length,
                itemBuilder: (_, i) {
                  final periodo = periodos[i];
                  final cursosEnPeriodo = matriculaPorPeriodo[periodo]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del período
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        child: Text(
                          "📝 Periodo: $periodo",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      // Tarjetas de cursos en este período
                      ...cursosEnPeriodo.map((curso) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: const Icon(
                              Icons.class_,
                              color: Color(0xFFC3A38E),
                            ),
                            title: Text(
                              "${curso.nombreCurso} (${curso.codigoCurso})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Grupo: ${curso.nombreGrupo}"),
                                Text("Carrera: ${curso.carreraEstudiante}"),
                                Text(
                                  "Matriculado el: ${formatter.format(curso.fechaMatricula)}",
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Matricularme'),
                onPressed: () async {
                  final result = await Get.to<bool>(
                    () => const MatriculaNuevaScreen(),
                  );

                  if (result == true) {
                    await controller.cargarMatricula();
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
