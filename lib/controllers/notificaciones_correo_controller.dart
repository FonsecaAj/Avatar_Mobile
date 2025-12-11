import 'package:get/get.dart';
import 'package:modulo_mobil/models/notificaciones_correo_response.dart';
import 'package:modulo_mobil/services/notificaciones_correo_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';

class NotificacionesController extends GetxController {
  final NotificacionesApiService notificacionesService =
      NotificacionesApiService();

  // Estado de carga mientras se envía el correo
  var enviando = false.obs;

  /// Envía un correo usando la API de notificaciones.
  ///
  /// Si quieres que el email de destino sea el del usuario logueado por defecto,
  /// puedes dejar [emailDestino] en null y tomarlo desde LoginController.
  Future<bool> enviarCorreo({
    String? emailDestino,
    required String asunto,
    required String mensaje,
  }) async {
    enviando.value = true;

    // Obtener usuario logueado si no se pasa emailDestino
    final loginController = Get.find<LoginController>();
    final usuario = loginController.usuarioActual.value;

    final email = emailDestino ?? usuario?.email ?? '';

    if (email.isEmpty) {
      enviando.value = false;
      return false;
    }

    final request = NotificacionEmailRequest(
      email: email,
      asunto: asunto,
      mensaje: mensaje,
    );

    final ok = await notificacionesService.enviarNotificacionEmail(request);

    enviando.value = false;
    return ok;
  }
}
