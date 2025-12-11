import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/models/direcciones_response.dart';
import 'package:modulo_mobil/services/loginService.dart';

class DireccionesService {
  final client = http.Client();
  final loginService = LoginApiService();
  final String baseUrl = "https://tiusr20pl.cuc-carrera-ti.ac.cr/API_DIRECCIONES/api";

  Future<Map<String, String>> _headers() async {
    final token = await loginService.obtenerAccessToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future<List<Provincia>> obtenerProvincias() async {
    try {
      final url = Uri.parse("$baseUrl/provincias");
      final resp = await client.get(url, headers: await _headers());

      if (resp.statusCode != 200) {
        throw Exception("Error HTTP: ${resp.statusCode}");
      }

      final jsonResp = jsonDecode(resp.body);
      if (jsonResp["responseObject"] == null) return [];

      return (jsonResp["responseObject"] as List)
          .map((e) => Provincia.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error en obtenerProvincias: $e");
      rethrow;
    }
  }

  Future<List<Canton>> obtenerCantones(int idProvincia) async {
    try {
      final url = Uri.parse("$baseUrl/cantones?provincia=$idProvincia");
      final resp = await client.get(url, headers: await _headers());

      if (resp.statusCode != 200) {
        throw Exception("Error HTTP: ${resp.statusCode}");
      }

      final jsonResp = jsonDecode(resp.body);
      if (jsonResp["responseObject"] == null) return [];

      return (jsonResp["responseObject"] as List)
          .map((e) => Canton.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error en obtenerCantones: $e");
      rethrow;
    }
  }

  Future<List<Distrito>> obtenerDistritos(int idProvincia, int idCanton) async {
    try {
      final url = Uri.parse("$baseUrl/distritos?provincia=$idProvincia&canton=$idCanton");
      final resp = await client.get(url, headers: await _headers());

      if (resp.statusCode != 200) {
        throw Exception("Error HTTP: ${resp.statusCode}");
      }

      final jsonResp = jsonDecode(resp.body);
      if (jsonResp["responseObject"] == null) return [];

      return (jsonResp["responseObject"] as List)
          .map((e) => Distrito.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ Error en obtenerDistritos: $e");
      rethrow;
    }
  }
}
