import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/perfil_usuario.dart';
import 'package:modulo_mobil/services/loginService.dart';


class PerfilApiService {
  final client = http.Client();
  final loginService = LoginApiService(); // Asume que este servicio existe y funciona

  // URL base proporcionada
  static const String _baseUrl = 'https://tiusr20pl.cuc-carrera-ti.ac.cr/perfilusuario';

  // --- 1. Endpoint: Cargar Perfil de Usuario ---
  
  // URL: https://tiusr20pl.cuc-carrera-ti.ac.cr/perfilusuario/api/perfil/mobile?email=jocs%40cuc.cr
  Future<PerfilUsuario?> obtenerPerfil(String email) async {
    // 1. Obtener el token de acceso
    final token = await loginService.obtenerAccessToken();
    
    // Codificar el email para la URL
    final encodedEmail = Uri.encodeComponent(email); 

    // 2. Construir la URL completa para obtener el perfil
    final url = Uri.parse(
      "$_baseUrl/api/perfil/mobile?email=$encodedEmail",
    );

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
        
        // Usamos el fromJson de PerfilUsuario sobre el responseObject
        return PerfilUsuario.fromJson(jsonResp["responseObject"] as Map<String, dynamic>);
      } else {
        // Manejar errores de API o token no válido
        print('Error al cargar perfil. Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return null;
      }
    } catch (e) {
      print('Excepción en obtenerPerfil: $e');
      return null;
    }
  }

  // --- 2. Endpoint: Actualizar Perfil de Usuario ---

  // URL: https://tiusr20pl.cuc-carrera-ti.ac.cr/perfilusuario/api/perfil/mobile/editar
  Future<bool> actualizarPerfil({
    required String email, 
    required String direccion, 
    required String telefono,
  }) async {
    // 1. Obtener el token de acceso
    final token = await loginService.obtenerAccessToken();

    // 2. Construir la URL completa para la edición
    final url = Uri.parse("$_baseUrl/api/perfil/mobile/editar");

    // 3. Crear el body de la solicitud (tal como lo requiere la API)
    final body = jsonEncode({
      "email": email,
      "direccion": direccion,
      "telefono": telefono,
    });
    
    try {
      // 4. Realizar la solicitud PUT (asumiendo que la edición es PUT o POST)
      final resp = await client.put( // Se usa PUT o POST para edición, asumo PUT o revisa la doc.
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      // 5. Verificar el código de estado
      if (resp.statusCode == 200) {
        // Puedes opcionalmente decodificar y revisar el mensaje si el API lo proporciona
        // final jsonResp = jsonDecode(resp.body);
        // print('Actualización exitosa: ${jsonResp["message"]}');
        return true;
      } else {
        final jsonResp = jsonDecode(resp.body);
        print('Error al actualizar perfil. Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return false;
      }
    } catch (e) {
      print('Excepción en actualizarPerfil: $e');
      return false;
    }
  }
}