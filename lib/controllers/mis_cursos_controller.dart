// lib/controllers/mis_cursos_controller.dart

import 'package:get/get.dart';
import 'package:modulo_mobil/services/mis_cursos_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/curso_response.dart';

class MisCursosController extends GetxController {
  final cursosService = CursosService();

  var cursos = <CursoResponse>[].obs;
  var cursosFiltrados = <CursoResponse>[].obs;

  var cargando = false.obs;
  var filtro = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarCursos();
    ever(filtro, (_) => _aplicarFiltro());
  }

  Future<void> cargarCursos() async {
    cargando.value = true;

    final loginController = Get.find<LoginController>();
    final cedula = loginController.usuarioActual.value?.identificacion ?? "";

    final data = await cursosService.obtenerMisCursos(cedula);
    cursos.assignAll(data ?? []);

    _aplicarFiltro();
    cargando.value = false;
  }

  void actualizarFiltro(String texto) {
    filtro.value = texto;
  }

  void _aplicarFiltro() {
    final texto = filtro.value.toLowerCase().trim();

    // Base: solo cursos del período actual si existen
    List<CursoResponse> base = cursos.toList();
    final actuales = base.where((c) => c.esPeriodoActual).toList();
    if (actuales.isNotEmpty) {
      base = actuales;
    }

    if (texto.isEmpty) {
      cursosFiltrados.assignAll(base);
      return;
    }

    cursosFiltrados.assignAll(
      base.where(
        (c) =>
            c.nombre.toLowerCase().contains(texto) ||
            c.codigoCurso.toLowerCase().contains(texto) ||
            c.grupo.toLowerCase().contains(texto) ||
            c.profesor.toLowerCase().contains(texto) ||
            c.periodo.toLowerCase().contains(texto),
      ),
    );
  }
}
