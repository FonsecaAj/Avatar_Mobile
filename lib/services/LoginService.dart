import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginApiService {
  static const String _baseUrl =
      'https://tiusr20pl.cuc-carrera-ti.ac.cr/USR5Login';
  final http.Client _client;
  final FlutterSecureStorage _storage;

  LoginApiService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  Future<LoginResponse?> login(String email, String password) async {
    try {
      final uri = Uri.parse('$_baseUrl/login');

      final response = await _client.post(
        uri,
        headers: {'usuario': email, 'contrasenna': password},
      );

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return LoginResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  Future<RefreshResponse?> refreshToken(String refreshToken) async {
    try {
      final uri = Uri.parse('$_baseUrl/refresh');
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return RefreshResponse.fromJson(decoded);
      }
      return null;
    } catch (e) {
      print('Error en refresh: $e');
      return null;
    }
  }

  Future<bool> validateToken(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/validate');
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          return decoded == true;
        } catch (e) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout(String accessToken) async {
    try {
      final uri = Uri.parse('$_baseUrl/logout');
      final authHeader = accessToken.startsWith('Bearer ')
          ? accessToken
          : 'Bearer $accessToken';

      final response = await _client.post(
        uri,
        headers: {'Authorization': authHeader},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error en logout: $e');
      return false;
    }
  }

  Future<void> guardarCredenciales(
    LoginResponse response,
    bool recordarme,
  ) async {
    try {
      await _storage.write(key: 'access_token', value: response.accessToken);
      await _storage.write(key: 'refresh_token', value: response.refreshToken);
      await _storage.write(key: 'usuario_id', value: response.usuarioId);
      await _storage.write(
        key: 'expires_in',
        value: response.expiresIn.toIso8601String(),
      );
      await _storage.write(key: 'recordarme', value: recordarme.toString());
    } catch (e) {
      print('Error guardando credenciales: $e');
    }
  }

  Future<void> limpiarCredenciales() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error limpiando credenciales: $e');
    }
  }

  Future<String?> obtenerAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> obtenerRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<String?> obtenerUsuarioId() async {
    return await _storage.read(key: 'usuario_id');
  }

  Future<bool> debeRecordar() async {
    try {
      final recordar = await _storage.read(key: 'recordarme');
      return recordar == 'true';
    } catch (e) {
      return false;
    }
  }
}

class LoginResponse {
  final DateTime expiresIn;
  final String accessToken;
  final String refreshToken;
  final String usuarioId; // Esto es el EMAIL

  LoginResponse({
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
    required this.usuarioId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      expiresIn: DateTime.parse(json['expires_in']),
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      usuarioId: json['usuarioID'] ?? '', // Este es el email
    );
  }
}

class RefreshResponse {
  final DateTime expiresIn;
  final String accessToken;
  final String refreshToken;

  RefreshResponse({
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      expiresIn: DateTime.parse(json['expires_in']),
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}
