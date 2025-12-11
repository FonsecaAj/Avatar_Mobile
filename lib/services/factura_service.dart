import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/services/loginService.dart';
import 'package:modulo_mobil/models/factura_response.dart';

class FacturaService {
  final client = http.Client();
  final loginService = LoginApiService();

  // Antes: https://tiusr20pl.cuc-carrera-ti.ac.cr/admfacturacion/api
  // Ahora pasamos por el gateway
  final String baseUrl =
      "https://tiusr20pl.cuc-carrera-ti.ac.cr/gateway/admfacturacion/api";

  Future<List<Factura>?> obtenerFacturas(String cedula) async {
    try {
      final token = await loginService.obtenerAccessToken();

      final url = Uri.parse("$baseUrl/factura/usuario/$cedula");

      print("URL FACTURAS: $url");
      print("TOKEN FACTURAS: $token");

      final resp = await client.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (resp.statusCode != 200) {
        print("Error facturas: ${resp.statusCode}");
        print(resp.body);
        return [];
      }

      final data = jsonDecode(resp.body);

      if (data["responseObject"] == null) return [];

      final lista = data["responseObject"] as List;

      return lista.map((e) => Factura.fromJson(e)).toList();
    } catch (e) {
      print("Error facturas: $e");
      return [];
    }
  }
}
