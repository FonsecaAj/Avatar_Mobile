import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/matricula_controller.dart';
import 'package:modulo_mobil/screens/matricula_nueva_screen.dart';

class MatriculaScreen extends StatelessWidget {
  const MatriculaScreen({super.key});

  Future<void> _abrirNuevaMatricula(MatriculaController controller) async {
    final result = await Get.to<bool>(() => const MatriculaNuevaScreen());

    // Si la pantalla de nueva matrícula devolvió true,
    // recargamos la matrícula actual desde el API
    if (result == true) {
      await controller.cargarMatricula();
      Get.snackbar(
        'Matrícula actualizada',
        'Se ha agregado un curso a tu matrícula actual.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatriculaController());
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');

    return MainLayout(
      title: "Matrícula Actual",
      currentIndex: 2, // pestaña Matrícula
      child: Obx(() {
        // -------- Estado de carga --------
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // -------- Sin datos: mensaje + botón de matricular --------
        if (controller.matriculaList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "No hay cursos matriculados.\nPuedes iniciar una nueva matrícula.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 220,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Matricularme'),
                  onPressed: () => _abrirNuevaMatricula(controller),
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
            // Lista de matrículas con padding para no tapar el botón
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

            // Botón fijo abajo para agregar nueva matrícula
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Matricularme'),
                  onPressed: () => _abrirNuevaMatricula(controller),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
