import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/notificaciones_correo_response.dart';
import 'package:modulo_mobil/services/loginService.dart';

class NotificacionesApiService {
  final client = http.Client();
  final loginService = LoginApiService();

  // URL base proporcionada
  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/ipn3notificaciones';

  /// Endpoint: Enviar notificación por correo
  ///
  /// URL: https://tiusr20pl.cuc-carrera-ti.ac.cr/ipn3notificaciones/api/notificar
  Future<bool> enviarNotificacionEmail(NotificacionEmailRequest data) async {
    // 1. Obtener el token de acceso (mismo patrón que en otros servicios)
    final token = await loginService.obtenerAccessToken();

    // 2. Construir la URL completa
    final url = Uri.parse("$_baseUrl/api/notificar");

    // 3. Crear el body de la solicitud
    final body = jsonEncode(data.toJson());

    try {
      // 4. Realizar la solicitud POST
      final resp = await client.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      // 5. Verificar el código de estado
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        // Opcional: puedes inspeccionar resp.body si la API devuelve un mensaje
        return true;
      } else {
        print(
            'Error al enviar notificación. Status: ${resp.statusCode}, Body: ${resp.body}');
        return false;
      }
    } catch (e) {
      print('Excepción en enviarNotificacionEmail: $e');
      return false;
    }
  }
}
