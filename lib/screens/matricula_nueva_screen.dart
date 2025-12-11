import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/matricula_nueva_controller.dart';
import 'package:modulo_mobil/models/matricula_lookups.dart';

class MatriculaNuevaScreen extends StatelessWidget {
  const MatriculaNuevaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatriculaNuevaController());

    return Scaffold(
      appBar: AppBar(title: const Text('Matricularme')),
      body: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Periodo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<PeriodoMatricula>(
                value: controller.periodoSeleccionado.value,
                hint: const Text('Seleccione período'),
                isExpanded: true,
                items: controller.periodos
                    .map(
                      (p) => DropdownMenuItem<PeriodoMatricula>(
                        value: p,
                        child: Text(p.descripcion),
                      ),
                    )
                    .toList(),
                onChanged: (PeriodoMatricula? value) {
                  if (value != null) controller.seleccionarPeriodo(value);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Curso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<CursoMatricula>(
                value: controller.cursoSeleccionado.value,
                hint: const Text('Seleccione curso'),
                isExpanded: true,
                items: controller.cursos
                    .map(
                      (c) => DropdownMenuItem<CursoMatricula>(
                        value: c,
                        child: Text('${c.codigo} - ${c.nombre}'),
                      ),
                    )
                    .toList(),
                onChanged: (CursoMatricula? value) {
                  if (value != null) controller.seleccionarCurso(value);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Grupo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<GrupoMatricula>(
                value: controller.grupoSeleccionado.value,
                hint: const Text('Seleccione grupo'),
                isExpanded: true,
                items: controller.gruposFiltrados
                    .map(
                      (g) => DropdownMenuItem<GrupoMatricula>(
                        value: g,
                        child: Text(
                          '${g.nombreGrupo} · ${g.horario ?? ''} ${g.profesor != null ? '· ${g.profesor}' : ''}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (GrupoMatricula? value) {
                  if (value != null) controller.seleccionarGrupo(value);
                },
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar matrícula'),
                  onPressed: () async {
                    final ok = await controller.confirmarMatricula();

                    if (ok) {
                      Get.snackbar(
                        'Matrícula exitosa',
                        'Se registró la matrícula correctamente.',
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      Get.back(result: true);
                    } else {
                      // opcional: mostrar mensaje si el controller puso error
                      if (controller.error.isNotEmpty) {
                        Get.snackbar(
                          'Error',
                          controller.error.value,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red[200],
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
