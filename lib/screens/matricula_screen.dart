import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/matricula_controller.dart'; 

class MatriculaScreen extends StatelessWidget {
  const MatriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador (o encontrarlo)
    final controller = Get.put(MatriculaController());
    
    // Formato de fecha para mostrar
    final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm');

    return MainLayout(
      title: "Matrícula Actual",
      // Asumiendo que el índice 2 es la Matrícula/Prematrícula en el BottomNavigationBar
      currentIndex: 2, 
      child: Obx(() {
        
        // --- Estado de Carga ---
        if (controller.cargando.value) { 
  return const Center(child: CircularProgressIndicator());
}
        // --- Estado sin Datos ---
        if (controller.matriculaList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "No hay cursos matriculados o la consulta falló. Intente de nuevo más tarde.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          );
        }

        // --- Datos Cargados: Agrupados por Período ---
        final matriculaPorPeriodo = controller.matriculaPorPeriodo;
        final periodos = matriculaPorPeriodo.keys.toList();
        
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          // Contamos el número de períodos (grupos de tarjetas)
          itemCount: periodos.length, 
          itemBuilder: (_, i) {
            final periodo = periodos[i];
            final cursosEnPeriodo = matriculaPorPeriodo[periodo]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Título del Período
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  child: Text(
                    "📝 Periodo: $periodo",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                
                // Lista de Cursos en este Período
                ...cursosEnPeriodo.map((curso) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: const Icon(Icons.class_, color: Color(0xFFC3A38E)),
                      title: Text(
                        // Nombre del Curso y Código
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
                          // Formateamos la fecha a un formato legible
                          Text("Matriculado el: ${formatter.format(curso.fechaMatricula)}"),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 20),
              ],
            );
          },
        );
      }),
    );
  }
}