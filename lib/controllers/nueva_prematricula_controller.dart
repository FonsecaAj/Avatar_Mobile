import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/nueva_prematricula_response.dart';
import 'package:modulo_mobil/services/prematricula_service.dart';

class NuevaPrematriculaController extends GetxController {
  // Servicio de prematrícula + login
  final PrematriculaService prematriculaService = PrematriculaService();
  final LoginController loginController = Get.find<LoginController>();

  // Datos de prueba para los Dropdowns (por ahora solo nombres)
  final List<String> carreras = [
    'Ingeniería de Sistemas',
    'Contabilidad',
    'Administración de Empresas',
  ];

  final Map<String, List<String>> cursosPorCarrera = {
    'Ingeniería de Sistemas': [
      'Programación I',
      'Estructura de Datos',
      'Bases de Datos',
    ],
    'Contabilidad': [
      'Contabilidad General',
      'Finanzas I',
      'Auditoría',
    ],
    'Administración de Empresas': [
      'Gestión Empresarial',
      'Marketing',
      'Recursos Humanos',
    ],
  };

  // Variables reactivas para el formulario
  var carreraSeleccionada = Rxn<String>();
  var cursoSeleccionado = Rxn<String>();
  final periodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Estado de carga al enviar
  var enviando = false.obs;

  void limpiarFormulario() {
    carreraSeleccionada.value = null;
    cursoSeleccionado.value = null;
    periodoController.clear();
    observacionesController.clear();
  }

  // Lógica para actualizar los cursos cuando cambia la carrera
  void actualizarCurso(String? nuevaCarrera) {
    carreraSeleccionada.value = nuevaCarrera;
    cursoSeleccionado.value = null;
  }

  // Enviar prematrícula al backend
  Future<void> enviarPrematricula() async {
    // Validaciones básicas de formulario
    if (!(formKey.currentState?.validate() ?? false) ||
        carreraSeleccionada.value == null ||
        cursoSeleccionado.value == null) {
      Get.snackbar(
        '⚠️ Error de Formulario',
        'Por favor, selecciona Carrera y Curso, y completa los campos obligatorios.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Obtener el estudiante logueado
    final usuario = loginController.usuarioActual.value;
    if (usuario == null) {
      Get.snackbar(
        'Error',
        'No se encontró información del usuario. Inicia sesión nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Ajusta estos mapeos a los IDs reales que maneja tu backend
    // Por ejemplo, si ya tienes listas de carreras/cursos con ID, usa esos modelos.
    final String carrera = carreraSeleccionada.value!;
    final String curso = cursoSeleccionado.value!;

    // EJEMPLO SIMPLE: usar el índice como ID (cámbialo por tus IDs reales)
    final int idCarrera = carreras.indexOf(carrera) + 1; // TODO: reemplazar
    final List<String> cursosDeCarrera = cursosPorCarrera[carrera] ?? [];
    final int idCurso = cursosDeCarrera.indexOf(curso) + 1; // TODO: reemplazar

    // Periodo: si el backend espera un ID numérico de periodo, mapéalo aquí.
    // Por ahora se intenta parsear el texto (Ej: "2026-1" -> 20261 o similar).
    // Ajusta según tu API.
    final String periodoTexto = periodoController.text.trim();
    int idPeriodo;
    try {
      idPeriodo = int.parse(periodoTexto); // TODO: adapta a tu esquema de periodos
    } catch (_) {
      Get.snackbar(
        'Error',
        'El período debe ser un número válido (ajusta esta lógica según tu API).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // ID de estudiante: ajusta según tu modelo de usuario
    // Ejemplos posibles:
    // final int idEstudiante = usuario.idEstudiante;
    // o si solo tienes la cédula como String y tu API la acepta como int:
    int idEstudiante;
    try {
      idEstudiante = int.parse(usuario.identificacion);
    } catch (_) {
      Get.snackbar(
        'Error',
        'No se pudo obtener el ID del estudiante desde la identificación.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final request = PrematriculaRequest(
      idPrematricula: 0,
      idEstudiante: idEstudiante,
      idCarrera: idCarrera,
      idCurso: idCurso,
      observaciones: observacionesController.text.trim(),
      idPeriodo: idPeriodo,
    );

    enviando.value = true;
    final ok = await prematriculaService.crearPrematricula(request);
    enviando.value = false;

    if (ok) {
      Get.snackbar(
        '✅ Solicitud Enviada',
        'Tu solicitud de pre-matrícula para $curso ha sido registrada con éxito.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      limpiarFormulario();
    } else {
      Get.snackbar(
        '❌ Error',
        'No se pudo registrar la pre-matrícula. Inténtalo de nuevo más tarde.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
