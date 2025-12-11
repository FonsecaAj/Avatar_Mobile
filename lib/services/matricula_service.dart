// Archivo: lib/services/matricula_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/matricula_response.dart';
import 'package:modulo_mobil/models/matricula_request.dart';
import 'package:modulo_mobil/services/loginService.dart';
import 'package:modulo_mobil/models/matricula_lookups.dart';

class MatriculaApiService {
  final client = http.Client();
  final loginService = LoginApiService();

  // URL base proporcionada para el servicio de matrícula
  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/APIMAT2';

  // --- Endpoint: Consultar Matrícula de Estudiante ---
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
      // 1. Obtener el token de acceso
      final token = await loginService.obtenerAccessToken();

      print('Token: $token');

      // 2. Construir la URL completa para la consulta
      final url = Uri.parse(
        "$_baseUrl/api/matricula/estudiante/$identificacion",
      );

      // LOG 2: Verificar la URL final
      print('LOG 2 URL: $url');

      // 3. Realizar la solicitud GET
      final resp = await client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // LOG 3: Verificar el código de estado y el cuerpo de la respuesta
      print('LOG 3 Status Code: ${resp.statusCode}');

      final jsonResp = jsonDecode(resp.body);
      print(
        'LOG 3 Response Body (JSON): ${resp.body.length > 300 ? resp.body.substring(0, 300) + '...' : resp.body}',
      );

      // 4. Verificar la respuesta
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

  // --- Endpoint: Crear Matrícula (POST /api/matricula) ---
  Future<bool> crearMatricula(MatriculaRequest request) async {
    print('===== INICIO crearMatricula =====');

    try {
      final token = await loginService.obtenerAccessToken();
      if (token == null) {
        print('No hay token de acceso');
        return false;
      }

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

      final jsonResp = jsonDecode(resp.body);
      final status = jsonResp["statusCode"] ?? resp.statusCode;
      final message = jsonResp["message"] ?? '';

      if (status == 201) {
        print('Matrícula creada correctamente.');
        return true;
      } else {
        print('Error al crear matrícula: $message');
        return false;
      }
    } catch (e) {
      print('EXCEPCIÓN en crearMatricula: $e');
      return false;
    } finally {
      print('===== FIN crearMatricula =====');
    }
  }

  // --- Endpoint: Lookups de matrícula (GET /api/matricula/lookups) ---
  Future<MatriculaLookups?> obtenerLookups() async {
    print('===== INICIO obtenerLookups =====');
    try {
      final token = await loginService.obtenerAccessToken();
      if (token == null || token.isEmpty) {
        print('ERROR: token null o vacío en obtenerLookups');
        return null;
      }

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
      print('Body obtenerLookups: ${resp.body}');

      // Si no es 200, igual intento leer el mensaje para que lo veas
      final jsonResp = jsonDecode(resp.body);

      if (resp.statusCode != 200) {
        print('ERROR API LOOKUPS: status != 200');
        print('Mensaje API: ${jsonResp["message"]}');
        return null;
      }

      final obj = jsonResp['responseObject'];
      if (obj == null) {
        print('ERROR: responseObject viene null en lookups');
        return null;
      }

      final lookups = MatriculaLookups.fromJson(obj as Map<String, dynamic>);

      print(
        'OK: lookups cargados. Periodos=${lookups.periodos.length}, Cursos=${lookups.cursos.length}, Grupos=${lookups.grupos.length}',
      );
      return lookups;
    } catch (e) {
      print('EXCEPCIÓN en obtenerLookups: $e');
      return null;
    } finally {
      print('===== FIN obtenerLookups =====');
    }
  }
}
