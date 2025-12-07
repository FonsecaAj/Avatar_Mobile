import 'package:get/get.dart';
import 'package:modulo_mobil/services/LoginService.dart';
import 'package:modulo_mobil/services/usuario_service.dart';
import 'package:modulo_mobil/services/parametro_service.dart';

class LoginController extends GetxController {
  final LoginApiService _api;
  final UsuarioService _usuarioService;
  final ParametroService _parametroService;

  LoginController({
    LoginApiService? api,
    UsuarioService? usuarioService,
    ParametroService? parametroService,
  }) : _api = api ?? LoginApiService(),
       _usuarioService = usuarioService ?? UsuarioService(),
       _parametroService = parametroService ?? ParametroService();

  final isLoading = false.obs;
  final error = RxnString();
  final isAuthenticated = false.obs;
  final Rx<UsuarioResponse?> usuarioActual = Rx<UsuarioResponse?>(null);

  // Dominio dinámico desde API
  final dominioPermitido = 'cuc.cr'.obs;

  @override
  void onInit() {
    super.onInit();
    _cargarDominioPermitido();
    _verificarSesionExistente();
  }

  Future<void> _cargarDominioPermitido() async {
    try {
      final dominio = await _parametroService.obtenerDominioPermitido();
      if (dominio != null && dominio.isNotEmpty) {
        dominioPermitido.value = dominio;
      }
    } catch (e) {
      print('Error cargando dominio: $e');
    }
  }

  Future<void> _verificarSesionExistente() async {
    try {
      final debeRecordar = await _api.debeRecordar();
      if (!debeRecordar) return;

      final accessToken = await _api.obtenerAccessToken();
      if (accessToken == null) return;

      final isValid = await _api.validateToken(accessToken);
      if (isValid) {
        await _cargarDatosUsuario(accessToken);
        isAuthenticated.value = true;
        Future.delayed(Duration.zero, () {
          if (Get.currentRoute == '/login') {
            Get.offAllNamed('/home');
          }
        });
      } else {
        final renovado = await renovarSesion();
        if (!renovado) {
          // Refresh falló, limpiar credenciales y quedar en /login
          await _api.limpiarCredenciales();
          isAuthenticated.value = false;
        }
      }
    } catch (e) {
      print('Error verificando sesión: $e');
    }
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool recordarme,
  }) async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await _api.login(email, password);

      if (response != null) {
        await _api.guardarCredenciales(response, recordarme);
        await _cargarDatosUsuario(response.accessToken);

        isAuthenticated.value = true;
        return true;
      } else {
        error.value = 'Usuario y/o contraseña incorrectos';
        return false;
      }
    } catch (e) {
      error.value = 'Error al intentar iniciar sesión';
      print('Error en login: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _cargarDatosUsuario(String accessToken) async {
    try {
      final usuario = await _usuarioService.obtenerUsuarioActual(accessToken);
      usuarioActual.value = usuario;
    } catch (e) {
      print('Error cargando datos del usuario: $e');
    }
  }

  Future<bool> renovarSesion() async {
    try {
      final refreshToken = await _api.obtenerRefreshToken();
      if (refreshToken == null) return false;

      final refreshResponse = await _api.refreshToken(refreshToken);
      if (refreshResponse == null) return false;

      final usuarioId = await _api.obtenerUsuarioId();
      final debeRecordar = await _api.debeRecordar();

      final nuevaSesion = LoginResponse(
        expiresIn: refreshResponse.expiresIn,
        accessToken: refreshResponse.accessToken,
        refreshToken: refreshResponse.refreshToken,
        usuarioId: usuarioId ?? '',
      );

      await _api.guardarCredenciales(nuevaSesion, debeRecordar);
      await _cargarDatosUsuario(refreshResponse.accessToken);

      isAuthenticated.value = true;
      return true;
    } catch (e) {
      print('Error renovando sesión: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final accessToken = await _api.obtenerAccessToken();
      if (accessToken != null) {
        _api.logout(accessToken);
      }
    } catch (e) {
      print('Error en logout: $e');
    } finally {
      await _api.limpiarCredenciales();
      isAuthenticated.value = false;
      usuarioActual.value = null;
    }
  }

  Future<String?> obtenerAccessToken() async {
    return await _api.obtenerAccessToken();
  }
}
