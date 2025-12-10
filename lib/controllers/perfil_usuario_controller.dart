import 'package:get/get.dart';
import 'package:modulo_mobil/services/perfil_usuario_service.dart';
import 'package:modulo_mobil/models/perfil_usuario.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';

class PerfilController extends GetxController {
  
  // 1. Instancia del Servicio de API
  // Get.put() asegura que el servicio se inicie solo una vez.
  final PerfilApiService perfilService = Get.put(PerfilApiService());

  // 2. Variables Observables de Estado
  
  // Almacena la información del perfil del usuario (observable)
  var perfilUsuario = Rx<PerfilUsuario?>(null); 
  
  // Indicador de si el perfil está cargando por primera vez
  var cargando = false.obs;
  
  // Indicador de si el perfil se está actualizando
  var actualizando = false.obs;

  @override
  void onInit() {
    // Intenta cargar el perfil automáticamente al iniciar el controlador
    cargarPerfil();
    super.onInit();
  }

  // --- Método: Cargar Perfil ---
  Future<void> cargarPerfil() async {
    // Evita cargas duplicadas si ya está cargando
    if (cargando.value) return; 

    cargando.value = true;
    
    // 1. Obtener el email del usuario (usando un controlador de Login existente)
    // Asumo que tu LoginController tiene una propiedad para el usuario actual o el email
    final loginController = Get.find<LoginController>();
    final email = loginController.usuarioActual.value?.email ?? ""; 
    
    if (email.isEmpty) {
      cargando.value = false;
      Get.snackbar('Error', 'No se encontró el email del usuario para cargar el perfil.'); 
      return;
    }

    // 2. Llamar al servicio
    final perfilObtenido = await perfilService.obtenerPerfil(email);

    // 3. Actualizar el estado
    if (perfilObtenido != null) {
      perfilUsuario.value = perfilObtenido;
    } else {
      Get.snackbar('Error', 'No se pudo cargar la información del perfil desde el servidor.');
    }

    cargando.value = false;
  }
  
  // --- Método: Actualizar Perfil (Edición) ---
  Future<bool> actualizarPerfil({
    required String nuevaDireccion, 
    required String nuevoTelefono,
  }) async {
    // Evita actualizaciones duplicadas
    if (actualizando.value) return false;
    
    // Verificación de datos
    final perfilActual = perfilUsuario.value;
    if (perfilActual == null) {
      Get.snackbar('Error', 'Perfil no cargado. No se puede actualizar.');
      return false;
    }
    
    // Evitar llamar a la API si los datos no cambiaron
    if (perfilActual.direccion == nuevaDireccion && perfilActual.telefono == nuevoTelefono) {
        Get.snackbar('Información', 'No hay cambios para guardar.');
        return true;
    }
    
    actualizando.value = true;
    
    // Llamar al servicio de actualización
    final exito = await perfilService.actualizarPerfil(
      email: perfilActual.email, // El email es clave y se obtiene del modelo ya cargado
      direccion: nuevaDireccion, 
      telefono: nuevoTelefono,
    );
    
    // 4. Actualizar el estado del controlador si fue exitoso
    if (exito) {
      // Usamos copyWith para crear una nueva instancia y notificar a GetX
      perfilUsuario.value = perfilActual.copyWith(
        direccion: nuevaDireccion,
        telefono: nuevoTelefono,
      );
      Get.snackbar('Éxito', 'Perfil actualizado correctamente.', duration: Duration(seconds: 2));
    } else {
      Get.snackbar('Error', 'Fallo al actualizar el perfil en el servidor. Intente de nuevo.');
    }

    actualizando.value = false;
    return exito;
  }
}