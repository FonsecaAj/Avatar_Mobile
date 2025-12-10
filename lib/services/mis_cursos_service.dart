import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/services/loginService.dart';
import 'package:modulo_mobil/models/curso_response.dart';

class CursosService {
  final client = http.Client();
  final loginService = LoginApiService();

  Future<List<CursoResponse>?> obtenerMisCursos(String cedula) async {
    final token = await loginService.obtenerAccessToken();

    final url = Uri.parse(
      "https://tiusr20pl.cuc-carrera-ti.ac.cr/APIACD3/api/curso/miscursos?id=$cedula",
    );

    final resp = await client.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    final jsonResp = jsonDecode(resp.body);

    if (jsonResp["responseObject"] == null) return [];

    return (jsonResp["responseObject"] as List)
        .map((e) => CursoResponse.fromJson(e))
        .toList();
  }
}