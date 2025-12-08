import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/prematricula_response.dart';

class PrematriculaService {
  final String baseUrl = "https://tiusr20pl.cuc-carrera-ti.ac.cr/apimat1/api";

  Future<List<PrematriculaResponse>?> obtenerPrematricula(String cedula) async {
    try {
      final url = Uri.parse("$baseUrl/prematricula/estudiante/$cedula");

      final resp = await http.get(url);

      if (resp.statusCode != 200) return [];

      final jsonResp = json.decode(resp.body);

      final lista = jsonResp["responseObject"] as List;

      return lista.map((e) => PrematriculaResponse.fromJson(e)).toList();
    } catch (e) {
      print("Error prematrícula: $e");
      return [];
    }
  }
}
