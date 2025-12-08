import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/controllers/pagos_controller.dart';

class PagosScreen extends StatelessWidget {
  const PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PagosController());
    controller.cargarPagosPendientes();

    return MainLayout(
      title: 'Pagos',
      currentIndex: 3,
      child: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pagosPendientes.isEmpty) {
          return const Center(
            child: Text(
              "No tienes pagos pendientes.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.pagosPendientes.length,
          itemBuilder: (_, i) {
            final factura = controller.pagosPendientes[i];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                title: Text(
                  "Factura #${factura.idFactura}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text("Fecha: ${factura.fechaEmision.split('T')[0]}"),
                    Text("Monto: ₡${factura.total.toStringAsFixed(2)}"),
                    Text("Estado: ${factura.estado}"),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                      "Pago",
                      "Aquí iría el flujo de pago real.",
                      backgroundColor: Colors.greenAccent,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Pagar"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
