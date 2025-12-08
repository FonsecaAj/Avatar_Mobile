import 'package:get/get.dart';
import 'package:modulo_mobil/models/prematricula_response.dart';
import 'package:modulo_mobil/services/prematricula_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';

class PrematriculaController extends GetxController {
  final service = PrematriculaService();

  var prematriculas = <PrematriculaResponse>[].obs;
  var cargando = false.obs;

  Future<void> cargarPrematricula() async {
    cargando.value = true;

    final login = Get.find<LoginController>();
    final cedula = login.usuarioActual.value?.identificacion ?? "";

    prematriculas.value =
        await service.obtenerPrematricula(cedula) ?? [];

    cargando.value = false;
  }
}
