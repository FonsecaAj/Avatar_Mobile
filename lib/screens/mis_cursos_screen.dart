// lib/screens/mis_cursos_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/mis_cursos_controller.dart';

class MisCursosScreen extends StatelessWidget {
  const MisCursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MisCursosController());

    return MainLayout(
      title: "Mis Cursos",
      currentIndex: 1,
      child: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cursosFiltrados.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.cargarCursos,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                SizedBox(height: 120),
                Center(
                  child: Text(
                    "No tienes cursos registrados para el período actual.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Búsqueda local
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Buscar por nombre, código, grupo o profesor...",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: controller.actualizarFiltro,
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.cargarCursos,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cursosFiltrados.length,
                  itemBuilder: (_, i) {
                    final curso = controller.cursosFiltrados[i];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => _abrirDetalleCurso(context, curso),
                        leading: CircleAvatar(
                          backgroundColor: const Color(
                            0xFFC3A38E,
                          ).withOpacity(0.15),
                          child: const Icon(
                            Icons.book_outlined,
                            color: Color(0xFF2F496E),
                          ),
                        ),
                        title: Text(
                          curso.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F496E),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              curso.codigoCurso,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            if (curso.grupo.isNotEmpty)
                              Text(
                                "Grupo: ${curso.grupo}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                            if (curso.periodo.isNotEmpty)
                              Text(
                                curso.periodo,
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _abrirDetalleCurso(BuildContext context, dynamic curso) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                curso.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F496E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                curso.codigoCurso,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
              const SizedBox(height: 12),
              if (curso.grupo.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.group_outlined,
                      size: 18,
                      color: Color(0xFF2F496E),
                    ),
                    const SizedBox(width: 6),
                    Text("Grupo: ${curso.grupo}"),
                  ],
                ),
              if (curso.profesor.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: Color(0xFF2F496E),
                    ),
                    const SizedBox(width: 6),
                    Text("Profesor: ${curso.profesor}"),
                  ],
                ),
              ],
              if (curso.horario.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 18,
                      color: Color(0xFF2F496E),
                    ),
                    const SizedBox(width: 6),
                    Text("Horario: ${curso.horario}"),
                  ],
                ),
              ],
              if (curso.periodo.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF2F496E),
                    ),
                    const SizedBox(width: 6),
                    Text("Período: ${curso.periodo}"),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.grade_outlined, size: 18),
                      label: const Text('Notas'),
                      onPressed: () {
                        Get.snackbar(
                          'Notas',
                          'Enlace a Notas (pendiente de implementar).',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.history, size: 18),
                      label: const Text('Historial'),
                      onPressed: () {
                        Get.snackbar(
                          'Historial',
                          'Enlace a Historial (pendiente de implementar).',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
