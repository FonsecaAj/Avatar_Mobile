import 'package:get/get.dart';
import 'package:modulo_mobil/services/factura_service.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/factura_response.dart';

class FacturasController extends GetxController {
  final facturasService = FacturaService();
  var facturas = <Factura>[].obs;
  var cargando = false.obs;

  Future<void> cargarFacturas() async {
    cargando.value = true;

    final login = Get.find<LoginController>();
    final cedula = login.usuarioActual.value?.identificacion ?? "";

    print("CÉDULA USADA PARA FACTURAS: $cedula");

    facturas.value = await facturasService.obtenerFacturas(cedula) ?? [];

    cargando.value = false;
  }
}
