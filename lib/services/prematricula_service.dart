import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/prematricula_response.dart';
import 'package:modulo_mobil/models/nueva_prematricula_response.dart';
import 'package:modulo_mobil/services/loginService.dart';

class PrematriculaService {
  final String baseUrl = "https://tiusr20pl.cuc-carrera-ti.ac.cr/APIMAT1/api";
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
      final url = Uri.parse("$baseUrl/prematricula/estudiante/$cedula");
      final resp = await http.get(url, headers: await _headers());

      if (resp.statusCode != 200) return [];

      final jsonResp = json.decode(resp.body);
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
      final url = Uri.parse("$baseUrl/prematricula");

      final resp = await http.post(
        url,
        headers: await _headers(),
        body: jsonEncode(data.toJson()),
      );

      // Ajusta esta lógica según cómo responda exactamente tu API
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        // Opcional: podrías parsear el body si devuelve la prematrícula creada
        // final jsonResp = jsonDecode(resp.body);
        // ...
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
