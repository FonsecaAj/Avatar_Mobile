import 'dart:convert';
import 'package:http/http.dart' as http;

class ParametroService {
  static const String _baseUrl = 'https://tiusr20pl.cuc-carrera-ti.ac.cr/USR3';
  final http.Client _client;

  ParametroService({http.Client? client}) : _client = client ?? http.Client();

  /// Obtiene el dominio permitido desde la API (parámetro público DOMEST)
  Future<String?> obtenerDominioPermitido() async {
    try {
      final uri = Uri.parse('$_baseUrl/parametro/public/DOMEST');
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['valor'];
      }
      return null;
    } catch (e) {
      print('Error obteniendo dominio: $e');
      return null;
    }
  }
}
