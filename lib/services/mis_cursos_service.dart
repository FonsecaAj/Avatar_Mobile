// lib/services/mis_cursos_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/services/loginService.dart';
import 'package:modulo_mobil/models/curso_response.dart';

class CursosService {
  final client = http.Client();
  final loginService = LoginApiService();

  Future<List<CursoResponse>> obtenerMisCursos(String cedula) async {
    if (cedula.isEmpty) return [];

    final token = await loginService.obtenerAccessToken();

    final url = Uri.parse(
      "https://tiusr20pl.cuc-carrera-ti.ac.cr/APIACD3/api/curso/miscursos?id=$cedula",
    );

    print('===== INICIO obtenerMisCursos =====');
    print('URL: $url');

    final resp = await client.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print('Status obtenerMisCursos: ${resp.statusCode}');
    if (resp.body.length > 400) {
      print('Body (400 chars): ${resp.body.substring(0, 400)}...');
    } else {
      print('Body: ${resp.body}');
    }

    if (resp.statusCode != 200) {
      print('ERROR obtenerMisCursos: status != 200');
      return [];
    }

    final jsonResp = jsonDecode(resp.body);

    final list = jsonResp["responseObject"];
    if (list == null) {
      print('responseObject es null');
      return [];
    }

    final cursos = (list as List)
        .map((e) => CursoResponse.fromJson(e as Map<String, dynamic>))
        .toList();

    print(
      'OK obtenerMisCursos: se cargaron ${cursos.length} cursos (sin filtrar).',
    );
    print('===== FIN obtenerMisCursos =====');

    return cursos;
  }
}
