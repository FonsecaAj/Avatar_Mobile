import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/perfil_usuario.dart';
import 'package:modulo_mobil/services/loginService.dart';

class PerfilApiService {
  final client = http.Client();
  final loginService = LoginApiService();

  // Antes: https://tiusr20pl.cuc-carrera-ti.ac.cr/perfilusuario
  // Ahora: base del API Gateway para perfil
  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/gateway/api/perfil';

  // --- 1. Endpoint: Cargar Perfil de Usuario ---
  Future<PerfilUsuario?> obtenerPerfil(String email) async {
    // 1. Obtener el token de acceso
    final token = await loginService.obtenerAccessToken();

    // Codificar el email para la URL
    final encodedEmail = Uri.encodeComponent(email);

    // 2. Construir la URL completa para obtener el perfil
    // Coincide con UpstreamPathTemplate: /api/perfil/mobile
    final url = Uri.parse("$_baseUrl/mobile?email=$encodedEmail");

    try {
      // 3. Realizar la solicitud GET
      final resp = await client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // 4. Decodificar la respuesta
      final jsonResp = jsonDecode(resp.body);

      // 5. Verificar el código de estado y el responseObject
      if (resp.statusCode == 200 && jsonResp["responseObject"] != null) {
        return PerfilUsuario.fromJson(
            jsonResp["responseObject"] as Map<String, dynamic>);
      } else {
        print(
            'Error al cargar perfil. Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return null;
      }
    } catch (e) {
      print('Excepción en obtenerPerfil: $e');
      return null;
    }
  }

  // --- 2. Endpoint: Actualizar Perfil de Usuario ---
  Future<bool> actualizarPerfil({
    required String email,
    required String direccion,
    required String telefono,
  }) async {
    // 1. Obtener el token de acceso
    final token = await loginService.obtenerAccessToken();

    // 2. Construir la URL completa para la edición
    // Coincide con UpstreamPathTemplate: /api/perfil/mobile/editar
    final url = Uri.parse("$_baseUrl/mobile/editar");

    // 3. Crear el body de la solicitud (tal como lo requiere la API)
    final body = jsonEncode({
      "email": email,
      "direccion": direccion,
      "telefono": telefono,
    });

    try {
      // 4. Realizar la solicitud PUT
      final resp = await client.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      // 5. Verificar el código de estado
      if (resp.statusCode == 200) {
        return true;
      } else {
        final jsonResp = jsonDecode(resp.body);
        print(
            'Error al actualizar perfil. Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return false;
      }
    } catch (e) {
      print('Excepción en actualizarPerfil: $e');
      return false;
    }
  }
}
