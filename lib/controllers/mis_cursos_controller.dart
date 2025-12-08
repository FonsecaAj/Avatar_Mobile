import 'package:get/get.dart';
import 'package:modulo_mobil/services/mis_cursos_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/curso_response.dart';

class MisCursosController extends GetxController {
  final cursosService = CursosService();
  var cursos = <CursoResponse>[].obs;
  var cargando = false.obs;

  Future<void> cargarCursos() async {
    cargando.value = true;

    final loginController = Get.find<LoginController>();
    final cedula = loginController.usuarioActual.value?.identificacion ?? "";

    cursos.value = await cursosService.obtenerMisCursos(cedula) ?? [];

    cargando.value = false;
  }
}
