import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/prematricula_response.dart';
import 'package:modulo_mobil/models/nueva_prematricula_response.dart';
import 'package:modulo_mobil/services/loginService.dart';

class PrematriculaService {
  // Antes: https://tiusr20pl.cuc-carrera-ti.ac.cr/APIMAT1/api
  // Ahora: base del API Gateway para prematrícula
  final String baseUrl =
      "https://tiusr20pl.cuc-carrera-ti.ac.cr/gateway/api";
  final loginService = LoginApiService();

  Future<Map<String, String>> _headers() async {
    final token = await loginService.obtenerAccessToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<List<PrematriculaResponse>?> obtenerPrematricula(String cedula) async {
    try {
      // Coincide con UpstreamPathTemplate: /api/prematricula/estudiante/{cedula}
      final url = Uri.parse("$baseUrl/prematricula/estudiante/$cedula");
      final resp = await http.get(url, headers: await _headers());

      if (resp.statusCode != 200) return [];

      final jsonResp = json.decode(resp.body);
      if (jsonResp["responseObject"] == null) return [];

      final lista = jsonResp["responseObject"] as List;
      return lista.map((e) => PrematriculaResponse.fromJson(e)).toList();
    } catch (e) {
      print("Error prematrícula: $e");
      return [];
    }
  }

  /// Nuevo: crear/enviar una prematrícula
  Future<bool> crearPrematricula(PrematriculaRequest data) async {
    try {
      // Coincide con UpstreamPathTemplate: /api/prematricula
      final url = Uri.parse("$baseUrl/prematricula");

      final resp = await http.post(
        url,
        headers: await _headers(),
        body: jsonEncode(data.toJson()),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return true;
      } else {
        print("Error crearPrematricula: ${resp.statusCode} -> ${resp.body}");
        return false;
      }
    } catch (e) {
      print("Excepción en crearPrematricula: $e");
      return false;
    }
  }
}
