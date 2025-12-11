import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/matricula_nueva_controller.dart';
import 'package:modulo_mobil/models/matricula_lookups.dart';

class MatriculaNuevaScreen extends StatelessWidget {
  const MatriculaNuevaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MatriculaNuevaController());

    // Colores de tu layout principal
    const primaryBlue = Color(0xFF2F496E);
    const accentGold = Color(0xFFC3A38E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'Matricularme',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.error.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDC3545)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error_outline, color: Color(0xFFDC3545)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.error.value,
                          style: const TextStyle(
                            color: Color(0xFF8B1A1A),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Debug visual opcional
              Text(
                'Periodos: ${controller.periodos.length}  ·  '
                'Cursos: ${controller.cursos.length}  ·  '
                'Grupos filtrados: ${controller.gruposFiltrados.length}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              const Text(
                'Periodo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              DropdownButton<CursoMatricula>(
                value: controller.cursoSeleccionado.value,
                hint: const Text('Seleccione curso'),
                isExpanded: true,
                items: controller.cursos
                    .map(
                      (c) => DropdownMenuItem<CursoMatricula>(
                        value: c,
                        child: Text(
                          c.nombre.isNotEmpty
                              ? '${c.codigo} - ${c.nombre}'
                              : c.codigo,
                        ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
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
                          '${g.nombreGrupo} · ${g.nombreCurso} · '
                          'Cupo: ${g.cupoDisponible}/${g.cupoMaximo}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (GrupoMatricula? value) {
                  if (value != null) controller.seleccionarGrupo(value);
                },
              ),

              const SizedBox(height: 20),

              // Resumen de selección
              Builder(
                builder: (_) {
                  final cursoSel = controller.cursoSeleccionado.value;
                  final grupoSel = controller.grupoSeleccionado.value;
                  final periodoSel = controller.periodoSeleccionado.value;

                  if (cursoSel == null ||
                      grupoSel == null ||
                      periodoSel == null) {
                    return const SizedBox();
                  }

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryBlue.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: primaryBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Matrícula seleccionada',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Curso: ${cursoSel.codigo} - ${cursoSel.nombre}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'Grupo: ${grupoSel.nombreGrupo}',
                                style: const TextStyle(fontSize: 13),
                              ),
                              Text(
                                'Período: ${periodoSel.descripcion}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Confirmar matrícula'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    final ok = await controller.confirmarMatricula();

                    if (ok) {
                      Get.offAllNamed('/matricula');

                      // Snackbar de éxito
                      Get.snackbar(
                        'Matrícula exitosa',
                        'Se registró la matrícula correctamente.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryBlue,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        icon: const Icon(Icons.check_circle, color: accentGold),
                      );
                    } else {
                      // Mostrar el motivo exacto del error
                      final msg = controller.error.value.isNotEmpty
                          ? controller.error.value
                          : 'No se pudo completar la matrícula.';
                      Get.snackbar(
                        'Error al matricular',
                        msg,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade700,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        icon: const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ),
                      );
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
