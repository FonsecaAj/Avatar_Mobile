import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/facturas_controller.dart';

class FacturasScreen extends StatelessWidget {
  const FacturasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FacturasController());

    controller.cargarFacturas();

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Facturas")),
      body: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.facturas.isEmpty) {
          return const Center(child: Text("No hay facturas"));
        }

        return ListView.builder(
          itemCount: controller.facturas.length,
          itemBuilder: (_, i) {
            final f = controller.facturas[i];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text("Factura #${f.idFactura} - ${f.estado}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Fecha: ${f.fechaEmision.split('T')[0]}"),
                    Text("Total: ₡${f.total.toStringAsFixed(2)}"),
                    Text("Detalle: ${f.detalles.first.descripcion}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
