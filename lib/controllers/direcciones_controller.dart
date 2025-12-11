import 'package:get/get.dart';
import 'package:modulo_mobil/services/direciones_service.dart';
import 'package:modulo_mobil/models/direcciones_response.dart';

class DireccionesController extends GetxController {
  final direccionesService = DireccionesService();
  
  var provincias = <Provincia>[].obs;
  var cantones = <Canton>[].obs;
  var distritos = <Distrito>[].obs;
  
  var cargandoProvincias = false.obs;
  var cargandoCantones = false.obs;
  var cargandoDistritos = false.obs;

  var provinciaSeleccionada = Rxn<Provincia>();
  var cantonSeleccionado = Rxn<Canton>();
  var distritoSeleccionado = Rxn<Distrito>();

  var errorCarga = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarProvincias();
  }

  Future<void> cargarProvincias() async {
    try {
      cargandoProvincias.value = true;
      errorCarga.value = '';

      final result = await direccionesService.obtenerProvincias();
      
      provincias.assignAll(result);
      
    } catch (e) {
      errorCarga.value = 'Error al cargar provincias: $e';
      provincias.clear();
    } finally {
      cargandoProvincias.value = false;
    }
  }

  Future<void> cargarCantones(int idProvincia) async {
    try {
      cargandoCantones.value = true;
      errorCarga.value = '';

      final result = await direccionesService.obtenerCantones(idProvincia);
      
      cantones.assignAll(result);
      
    } catch (e) {
      errorCarga.value = 'Error al cargar cantones: $e';
      cantones.clear();
    } finally {
      cargandoCantones.value = false;
    }
  }

  Future<void> cargarDistritos(int idProvincia, int idCanton) async {
    try {
      cargandoDistritos.value = true;
      errorCarga.value = '';

      final result = await direccionesService.obtenerDistritos(idProvincia, idCanton);
      
      distritos.assignAll(result);
      
    } catch (e) {
      errorCarga.value = 'Error al cargar distritos: $e';
      distritos.clear();
    } finally {
      cargandoDistritos.value = false;
    }
  }

  void seleccionarProvincia(Provincia? provincia) {
    provinciaSeleccionada.value = provincia;
    cantonSeleccionado.value = null;
    distritoSeleccionado.value = null;
    cantones.clear();
    distritos.clear();
    
    if (provincia != null) {
      cargarCantones(provincia.idProvincia);
    }
  }

  void seleccionarCanton(Canton? canton) {
    cantonSeleccionado.value = canton;
    distritoSeleccionado.value = null;
    distritos.clear();
    
    if (canton != null && provinciaSeleccionada.value != null) {
      cargarDistritos(provinciaSeleccionada.value!.idProvincia, canton.idCanton);
    }
  }

  void seleccionarDistrito(Distrito? distrito) {
    distritoSeleccionado.value = distrito;
  }

  void limpiarSeleccion() {
    provinciaSeleccionada.value = null;
    cantonSeleccionado.value = null;
    distritoSeleccionado.value = null;
    cantones.clear();
    distritos.clear();
  }
}
