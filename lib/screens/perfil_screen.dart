import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/perfil_usuario_controller.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/services/notification_service.dart';

class PerfilScreen extends StatelessWidget {
  PerfilScreen({super.key});

  final PerfilController controller = Get.put(PerfilController());

  final TextEditingController direccionCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Mi Perfil",
      currentIndex: 4,
      child: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.perfil.value == null) {
          return const Center(child: Text("No se pudo cargar el perfil."));
        }

        final p = controller.perfil.value!;
        direccionCtrl.text = p.direccion;
        telefonoCtrl.text = p.telefono;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              _campo("Nombre", p.nombre),
              _campo("Email", p.email),
              const SizedBox(height: 20),
              _editable("Dirección", direccionCtrl),
              const SizedBox(height: 20),
              _editable("Teléfono", telefonoCtrl),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final ok = await controller.actualizarPerfil(
                    telefonoCtrl.text,
                    direccionCtrl.text,
                  );

                  if (ok) {
                    NotificationService.showSuccess(
                        "Perfil actualizado correctamente");
                  } else {
                    NotificationService.showError(
                        "Error al actualizar perfil");
                  }
                },
                child: const Text("Guardar cambios"),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _campo(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: value),
    );
  }

  Widget _editable(String label, TextEditingController ctrl) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      controller: ctrl,
    );
  }
}
