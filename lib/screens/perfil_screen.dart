import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Asegúrate de que esta sea la ruta correcta a tu controlador
import 'package:modulo_mobil/controllers/perfil_usuario_controller.dart'; 
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/services/notification_service.dart'; // Asumo que existe

class PerfilScreen extends StatelessWidget {
  
  // Usamos Get.find() si el controlador fue inicializado en otro lugar (ej. Bindings)
  // Pero Get.put() es adecuado si este es el primer lugar donde lo inicializas.
  final PerfilController controller = Get.put(PerfilController());

  // Controladores de texto para los campos editables
  // Se recomienda inicializarlos con valores por defecto o vacíos.
  final TextEditingController direccionCtrl = TextEditingController();
  final TextEditingController telefonoCtrl = TextEditingController();

  PerfilScreen({super.key});

  // Widget helper para campos NO editables (datos de solo lectura)
  Widget _campo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          // Se usa para mostrar el valor de forma estática
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        // IMPORTANTE: Crear un nuevo TextEditingController solo para lectura
        controller: TextEditingController(text: value),
      ),
    );
  }

  // Widget helper para campos editables
  Widget _editable(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: ctrl,
        keyboardType: label == "Teléfono" ? TextInputType.phone : TextInputType.streetAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Mi Perfil",
      currentIndex: 4, // Asumiendo que es el índice 4 en tu navegación
      child: Obx(() {
        // --- 1. Estado de Carga Inicial ---
        if (controller.cargando.value && controller.perfilUsuario.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // --- 2. Estado de Error/No Encontrado ---
        if (controller.perfilUsuario.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No se pudo cargar el perfil.", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.cargarPerfil,
                  child: const Text("Intentar de Nuevo"),
                ),
              ],
            ),
          );
        }

        // --- 3. Perfil Cargado Correctamente ---
        final perfil = controller.perfilUsuario.value!;
        
        // ******************************************************
        // IMPORTANTE: Sincronizar los controladores de texto SOLO 
        // cuando el perfil cambie o se cargue inicialmente.
        // GetX gestiona este cambio, pero debemos evitar sobrescribir
        // la entrada del usuario constantemente. Usamos un condicional
        // para solo inicializar si están vacíos.
        if (direccionCtrl.text.isEmpty && perfil.direccion.isNotEmpty) {
          direccionCtrl.text = perfil.direccion;
        }
        if (telefonoCtrl.text.isEmpty && perfil.telefono.isNotEmpty) {
          telefonoCtrl.text = perfil.telefono;
        }
        // ******************************************************


        // Determina si el botón debe estar deshabilitado
        final bool isSaving = controller.actualizando.value;
        final bool canSave = !isSaving;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Campos de Solo Lectura ---
              _campo("Nombre", perfil.nombre),
              _campo("Email", perfil.email),
              _campo("Tipo Identificación", perfil.tipoIdentificacion),
              _campo("Identificación", perfil.identificacion),
              
              const Divider(height: 30),
              
              // --- Campos Editables ---
              Text("Información de Contacto", style: Get.textTheme.titleMedium),
              const SizedBox(height: 10),
              
              _editable("Dirección", direccionCtrl),
              _editable("Teléfono", telefonoCtrl),

              const SizedBox(height: 30),
              
              // --- Botón de Guardar ---
              ElevatedButton.icon(
                onPressed: canSave ? () async {
                  // Validación simple de no vacíos (puedes agregar más)
                  if (direccionCtrl.text.isEmpty || telefonoCtrl.text.isEmpty) {
                      NotificationService.showError("Dirección y Teléfono no pueden estar vacíos.");
                      return;
                  }
                  
                  // Llamada al método de actualización
                  final ok = await controller.actualizarPerfil(
                    nuevaDireccion: direccionCtrl.text,
                    nuevoTelefono: telefonoCtrl.text,
                  );

                  // Mostrar notificaciones usando el servicio (ya que el controller solo usa Get.snackbar)
                  // Esto se ejecuta solo si la actualización fue manejada correctamente por el controller/service
                  if (ok) {
                    NotificationService.showSuccess("Perfil actualizado correctamente");
                  } else {
                    // Si falla, el controlador ya debería haber mostrado un Get.snackbar de error, 
                    // pero podemos mostrar un fallback si es necesario.
                    // NotificationService.showError("Error al actualizar perfil");
                  }
                } : null, // Deshabilita si está guardando
                
                icon: isSaving 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                
                label: Text(isSaving ? "Guardando..." : "Guardar cambios"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}