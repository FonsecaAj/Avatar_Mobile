import 'package:get/get.dart';
import 'package:modulo_mobil/models/perfil_usuario.dart';
import 'package:modulo_mobil/services/perfil_usuario_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';

class PerfilController extends GetxController {
  final PerfilUsuarioService _service = PerfilUsuarioService();

  var loading = false.obs;
  var perfil = Rx<PerfilUsuario?>(null);

  @override
  void onInit() {
    super.onInit();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    loading.value = true;

    try {
      final login = Get.find<LoginController>();

      final email = login.usuarioActual.value?.email ?? "";
      final token = await login.obtenerAccessToken() ?? "";

      if (email.isEmpty || token.isEmpty) {
        loading.value = false;
        return;
      }

      final data = await _service.ObtenerPefilUsuario(email, token);
      perfil.value = data;
    } catch (e) {
      print("Error al cargar perfil: $e");
    } finally {
      loading.value = false;
    }
  }

  // Future<bool> actualizarPerfil(String telefono, String direccion) async {
  //   loading.value = true;

  //   try {
  //     final login = Get.find<LoginController>();
  //     final token = await login.obtenerAccessToken() ?? "";

  //     if (perfil.value == null || token.isEmpty) return false;

  //     final actualizado = PerfilUsuario(
  //       email: perfil.value!.email,
  //       nombre: perfil.value!.nombre,
  //       direccion: direccion,
  //       telefono: telefono,
  //     );

  //     return await _service.actualizarPerfil(actualizado, token);
  //   } catch (e) {
  //     print("Error al actualizar perfil: $e");
  //     return false;
  //   } finally {
  //     loading.value = false;
  //     await cargarPerfil();
  //   }
  // }
}
