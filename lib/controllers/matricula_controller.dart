// Archivo: lib/controllers/matricula_controller.dart

import 'package:get/get.dart';
import 'package:modulo_mobil/models/matricula_response.dart';
// Asumo que el nombre del servicio es MatriculaApiService
import 'package:modulo_mobil/services/matricula_service.dart'; 
import 'package:modulo_mobil/controllers/LoginController.dart'; 

class MatriculaController extends GetxController {
  
  // Nombres alineados con PrematriculaController
  final service = MatriculaApiService(); // Usa 'service'
  var matriculaList = <MatriculaResponse>[].obs; // Usa 'matriculaList'
  var cargando = false.obs; // Usa 'cargando'

  @override
  void onInit() {
    super.onInit();
    // Iniciar la carga de datos
    cargarMatricula();
  }

  // Método principal para cargar la matrícula
  Future<void> cargarMatricula() async {
    // 1. Iniciar la carga
    cargando.value = true; 

    try {
      // 2. Obtener la identificación del estudiante (Adaptado de PrematriculaController)
      final login = Get.find<LoginController>();
      final cedula = login.usuarioActual.value?.identificacion ?? "";

      // Si la cédula es vacía, detenemos la carga y salimos.
      if (cedula.isEmpty) {
        cargando.value = false;
        Get.snackbar("Error de Usuario", "No se encontró su identificación para consultar la matrícula.");
        return;
      }
      
      // 3. Llamar al servicio y asignar la lista
      // Asumo que obtenerMatricula devuelve List<MatriculaResponse> o null si falla.
      matriculaList.value = await service.obtenerMatricula(cedula);

    } catch (e) {
      print('Excepción en cargarMatricula: $e');
      matriculaList.clear();
      // En caso de error, el snakbar de la API debería ser suficiente, pero se deja un catch general.
    } finally {
      // 4. Detener la carga
      cargando.value = false;
    }
  }

  // Función para agrupar cursos por período (Necesario para la vista)
  Map<String, List<MatriculaResponse>> get matriculaPorPeriodo {
    final Map<String, List<MatriculaResponse>> grouped = {};
    for (var curso in matriculaList) {
      if (!grouped.containsKey(curso.periodoActual)) {
        grouped[curso.periodoActual] = [];
      }
      grouped[curso.periodoActual]!.add(curso);
    }
    return grouped;
  }
}