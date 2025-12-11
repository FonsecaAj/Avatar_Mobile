// lib/services/matricula_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/matricula_response.dart';
import 'package:modulo_mobil/models/matricula_request.dart';
import 'package:modulo_mobil/models/matricula_lookups.dart';
import 'package:modulo_mobil/services/loginService.dart';

class MatriculaApiService {
  final client = http.Client();
  final loginService = LoginApiService();

  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/APIMAT2';

  // ================== LOOKUPS ==================
  Future<MatriculaLookups?> obtenerLookups() async {
    print('===== INICIO obtenerLookups =====');
    try {
      final token = await loginService.obtenerAccessToken();

      final url = Uri.parse("$_baseUrl/api/matricula/lookups");
      print('URL obtenerLookups: $url');

      final resp = await client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Status obtenerLookups: ${resp.statusCode}');
      print(
        'Body obtenerLookups (primeros 400 chars): '
        '${resp.body.substring(0, resp.body.length > 400 ? 400 : resp.body.length)}',
      );

      if (resp.statusCode == 200) {
        final jsonResp = jsonDecode(resp.body);
        final data = jsonResp['responseObject'] as Map<String, dynamic>;
        final lookups = MatriculaLookups.fromJson(data);

        print(
          'OK: lookups cargados. '
          'Periodos=${lookups.periodos.length}, '
          'Cursos=${lookups.cursos.length}, '
          'Grupos=${lookups.grupos.length}',
        );

        return lookups;
      } else {
        print('ERROR obtenerLookups: ${resp.statusCode}');
        return null;
      }
    } catch (e) {
      print('EXCEPCIÓN en obtenerLookups: $e');
      return null;
    } finally {
      print('===== FIN obtenerLookups =====');
    }
  }

  // ================== CREAR MATRÍCULA ==================
  Future<void> crearMatricula(MatriculaRequest request) async {
    print('===== INICIO crearMatricula =====');
    print('DEBUG MATRICULA REQUEST => ${request.toJson()}');

    try {
      final token = await loginService.obtenerAccessToken();
      final url = Uri.parse("$_baseUrl/api/matricula");

      print('URL crearMatricula: $url');
      print('Body crearMatricula (toJson): ${request.toJson()}');

      final resp = await client.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      print('Status crearMatricula: ${resp.statusCode}');
      print('Body crearMatricula: ${resp.body}');

      dynamic jsonResp;
      if (resp.body.isNotEmpty) {
        jsonResp = jsonDecode(resp.body);
      }

      final msg = (jsonResp is Map<String, dynamic>)
          ? (jsonResp['message']?.toString() ??
                'Error al crear matrícula (sin mensaje).')
          : 'Error al crear matrícula.';

      if (resp.statusCode == 201) {
        print('Matrícula creada correctamente.');
        return; // ÉXITO
      } else {
        print('Error al crear matrícula: $msg');
        throw Exception(msg); // LANZAMOS ERROR PARA QUE LO VEA EL CONTROLLER
      }
    } catch (e) {
      print('EXCEPCIÓN en crearMatricula: $e');
      rethrow; // que lo maneje el controller
    } finally {
      print('===== FIN crearMatricula =====');
    }
  }

  // ================== OBTENER MATRÍCULA (YA LA TENÍAS) ==================
  Future<List<MatriculaResponse>> obtenerMatricula(
    String identificacion,
  ) async {
    print('====================================================');
    print(
      'INICIO: Llamada a obtenerMatricula(Identificación: $identificacion)',
    );
    print('====================================================');

    List<MatriculaResponse> matricula = [];

    try {
      final token = await loginService.obtenerAccessToken();
      print('Token: $token');

      final url = Uri.parse(
        "$_baseUrl/api/matricula/estudiante/$identificacion",
      );
      print('LOG 2 URL: $url');

      final resp = await client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('LOG 3 Status Code: ${resp.statusCode}');
      final jsonResp = jsonDecode(resp.body);
      print(
        'LOG 3 Response Body (JSON): '
        '${resp.body.length > 300 ? resp.body.substring(0, 300) + '...' : resp.body}',
      );

      if (resp.statusCode == 200 && jsonResp["responseObject"] != null) {
        final List<dynamic> responseObject = jsonResp["responseObject"];

        if (responseObject.isEmpty) {
          print(
            'LOG 4 ÉXITO: API retornó 200, pero la lista responseObject está vacía.',
          );
          return [];
        }

        matricula = responseObject
            .map(
              (item) =>
                  MatriculaResponse.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        print(
          'LOG 5 ÉXITO: ${matricula.length} registros de matrícula procesados correctamente.',
        );
        return matricula;
      } else {
        print('LOG 4 ERROR API: Fallo en la solicitud.');
        print('Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return [];
      }
    } catch (e) {
      print(
        'LOG EXCEPCIÓN CRÍTICA: Se capturó una excepción durante la llamada o el parseo.',
      );
      print('Detalle de la excepción: $e');
      return [];
    } finally {
      print('====================================================');
      print('FIN: Llamada a obtenerMatricula');
      print('====================================================');
    }
  }
}
