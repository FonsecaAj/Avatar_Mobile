import 'dart:convert';
import 'package:http/http.dart' as http;

class UsuarioService {
  static const String _baseUrl = 'https://tiusr20pl.cuc-carrera-ti.ac.cr/USR1';
  final http.Client _client;

  UsuarioService({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene los datos completos del usuario autenticado
  Future<UsuarioResponse?> obtenerUsuarioActual(String accessToken) async {
    try {
      final email = _extraerEmailDelToken(accessToken);
      if (email == null) return null;

      final uri = Uri.parse('$_baseUrl/usuario/$email');

      final authHeader = accessToken.startsWith('Bearer ')
          ? accessToken
          : 'Bearer $accessToken';

      final response = await _client.get(
        uri,
        headers: {'Authorization': authHeader},
      );

      print('Usuario response status: ${response.statusCode}');
      print('Usuario response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // La API USR1 retorna BusinessLogicResponse
        if (decoded['responseObject'] != null) {
          return UsuarioResponse.fromJson(decoded['responseObject']);
        }

        return UsuarioResponse.fromJson(decoded);
      }

      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  /// Extrae el email del JWT token
  String? _extraerEmailDelToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = jsonDecode(decoded);

      return payloadMap['sub'] ?? payloadMap['email'];
    } catch (e) {
      print('Error extrayendo email del token: $e');
      return null;
    }
  }
}

class UsuarioResponse {
  final String email;
  final String nombre;
  final String identificacion;
  final int idRol;
  final String? rolNombre;
  final bool activo;

  UsuarioResponse({
    required this.email,
    required this.nombre,
    required this.identificacion,
    required this.idRol,
    this.rolNombre,
    required this.activo,
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) {
    return UsuarioResponse(
      email: json['email'] ?? json['Email'] ?? '',
      nombre: json['nombre'] ?? json['Nombre'] ?? '',
      identificacion: json['identificacion'] ?? json['Identificacion'] ?? '',
      idRol: json['idRol'] ?? json['IdRol'] ?? 0,
      rolNombre: json['rolNombre'] ?? json['RolNombre'],
      activo: json['activo'] ?? json['Activo'] ?? true,
    );
  }
}
