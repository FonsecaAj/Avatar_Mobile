import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modulo_mobil/services/loginService.dart';
import 'package:modulo_mobil/models/perfil_usuario.dart';

class PerfilUsuarioService {
  final client = http.Client();
  final loginService = LoginApiService();

  Future<List<PerfilUsuario>?> ObtenerPefilUsuario(String email) async {
    final token = await loginService.obtenerAccessToken();

    final url = Uri.parse(
      "https://tiusr20pl.cuc-carrera-ti.ac.cr/perfilusuario/api/perfil/mobile?id=$email",
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
        .map((e) => PerfilUsuario.fromJson(e))
        .toList();
  }
}
