import 'package:get/get.dart';
import 'package:modulo_mobil/services/factura_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/factura_response.dart';

class PagosController extends GetxController {
  final facturasService = FacturaService();

  var pagosPendientes = <Factura>[].obs;
  var cargando = false.obs;

  Future<void> cargarPagosPendientes() async {
    cargando.value = true;

    final login = Get.find<LoginController>();
    final cedula = login.usuarioActual.value?.identificacion ?? "";

    final lista = await facturasService.obtenerFacturas(cedula) ?? [];

    //FILtrADO AQUÍ
    pagosPendientes.value =
        lista.where((f) => f.estado == "Pendiente").toList();

    cargando.value = false;
  }
}
