import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/matricula_response.dart';
import 'package:modulo_mobil/services/loginService.dart';

class MatriculaApiService {
  final client = http.Client();
  final loginService = LoginApiService();

  // Antes: https://tiusr20pl.cuc-carrera-ti.ac.cr/APIMAT2
  // Ahora: pasamos por el API Gateway
  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/gateway/api/matricula';

  // --- Endpoint: Consultar Matrícula de Estudiante ---
  Future<List<MatriculaResponse>> obtenerMatricula(String identificacion) async {
    print('====================================================');
    print('INICIO: Llamada a obtenerMatricula(Identificación: $identificacion)');
    print('====================================================');

    List<MatriculaResponse> matricula = [];

    try {
      // 1. Obtener el token de acceso
      final token = await loginService.obtenerAccessToken();

      print('Token: $token');

      // 2. Construir la URL completa para la consulta (coincide con el UpstreamPathTemplate)
      final url = Uri.parse("$_baseUrl/estudiante/$identificacion");

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
        'LOG 3 Response Body (JSON): '
        '${resp.body.length > 300 ? resp.body.substring(0, 300) + '...' : resp.body}',
      );

      // 4. Verificar la respuesta
      if (resp.statusCode == 200 && jsonResp["responseObject"] != null) {
        final List<dynamic> responseObject = jsonResp["responseObject"];

        if (responseObject.isEmpty) {
          print(
              'LOG 4 ÉXITO: API retornó 200, pero la lista responseObject está vacía.');
          return [];
        }

        matricula = responseObject
            .map((item) =>
                MatriculaResponse.fromJson(item as Map<String, dynamic>))
            .toList();

        print(
            'LOG 5 ÉXITO: ${matricula.length} registros de matrícula procesados correctamente.');
        return matricula;
      } else {
        print('LOG 4 ERROR API: Fallo en la solicitud.');
        print('Status: ${resp.statusCode}, Mensaje: ${jsonResp["message"]}');
        return [];
      }
    } catch (e) {
      print(
          'LOG EXCEPCIÓN CRÍTICA: Se capturó una excepción durante la llamada o el parseo.');
      print('Detalle de la excepción: $e');
      return [];
    } finally {
      print('====================================================');
      print('FIN: Llamada a obtenerMatricula');
      print('====================================================');
    }
  }
}
