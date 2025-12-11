import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/perfil_usuario_controller.dart';
import 'package:modulo_mobil/controllers/direcciones_controller.dart';
import 'package:modulo_mobil/models/direcciones_response.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';
import 'package:modulo_mobil/services/notification_service.dart';


class PerfilScreen extends StatelessWidget {
  
  final PerfilController controller = Get.put(PerfilController());
  final DireccionesController direccionesController = Get.put(DireccionesController());

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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
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
        keyboardType: TextInputType.phone,
      ),
    );
  }

  // Widget para dropdown de Provincia
  Widget _dropdownProvincia() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(() {
        if (direccionesController.cargandoProvincias.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return DropdownButtonFormField<Provincia>(
          decoration: const InputDecoration(
            labelText: "Provincia",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: direccionesController.provinciaSeleccionada.value,
          items: direccionesController.provincias.map((provincia) {
            return DropdownMenuItem<Provincia>(
              value: provincia,
              child: Text(provincia.nombreProvincia),
            );
          }).toList(),
          onChanged: (Provincia? value) {
            direccionesController.seleccionarProvincia(value);
          },
        );
      }),
    );
  }

  // Widget para dropdown de Cantón
  Widget _dropdownCanton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(() {
        if (direccionesController.cargandoCantones.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final habilitado = direccionesController.provinciaSeleccionada.value != null;

        return DropdownButtonFormField<Canton>(
          decoration: const InputDecoration(
            labelText: "Cantón",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: direccionesController.cantonSeleccionado.value,
          items: habilitado
              ? direccionesController.cantones.map((canton) {
                  return DropdownMenuItem<Canton>(
                    value: canton,
                    child: Text(canton.nombreCanton),
                  );
                }).toList()
              : [],
          onChanged: habilitado
              ? (Canton? value) {
                  direccionesController.seleccionarCanton(value);
                }
              : null,
        );
      }),
    );
  }

  // Widget para dropdown de Distrito
  Widget _dropdownDistrito() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Obx(() {
        if (direccionesController.cargandoDistritos.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final habilitado = direccionesController.cantonSeleccionado.value != null;

        return DropdownButtonFormField<Distrito>(
          decoration: const InputDecoration(
            labelText: "Distrito",
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: direccionesController.distritoSeleccionado.value,
          items: habilitado
              ? direccionesController.distritos.map((distrito) {
                  return DropdownMenuItem<Distrito>(
                    value: distrito,
                    child: Text(distrito.nombreDistrito),
                  );
                }).toList()
              : [],
          onChanged: habilitado
              ? (Distrito? value) {
                  direccionesController.seleccionarDistrito(value);
                }
              : null,
        );
      }),
    );
  }

  // Método para obtener la dirección completa como string
  String _obtenerDireccionCompleta() {
    final provincia = direccionesController.provinciaSeleccionada.value;
    final canton = direccionesController.cantonSeleccionado.value;
    final distrito = direccionesController.distritoSeleccionado.value;

    if (provincia != null && canton != null && distrito != null) {
      return "${provincia.nombreProvincia}, ${canton.nombreCanton}, ${distrito.nombreDistrito}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Mi Perfil",
      currentIndex: 4,
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
        
        if (telefonoCtrl.text.isEmpty && perfil.telefono.isNotEmpty) {
          telefonoCtrl.text = perfil.telefono;
        }

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
              
              // --- Selector de Dirección en Cascada ---
              _dropdownProvincia(),
              _dropdownCanton(),
              _dropdownDistrito(),
              
              _editable("Teléfono", telefonoCtrl),

              const SizedBox(height: 30),
              
              // --- Botón de Guardar ---
              ElevatedButton.icon(
                onPressed: canSave ? () async {
                  
                  final direccionCompleta = _obtenerDireccionCompleta();
                  
                  // Validación
                  if (direccionCompleta.isEmpty) {
                    NotificationService.showError("Debe seleccionar Provincia, Cantón y Distrito.");
                    return;
                  }
                  
                  if (telefonoCtrl.text.isEmpty) {
                    NotificationService.showError("El Teléfono no puede estar vacío.");
                    return;
                  }
                  
                  // Confirmación
                  final confirmed = await NotificationService.showConfirmDialog(
                    title: 'Confirmar Actualización',
                    message: '¿Desea guardar los cambios en su dirección y teléfono?',
                    confirmText: 'Guardar',
                    cancelText: 'Cancelar',
                  );

                  if (!confirmed) {
                    NotificationService.showInfo('Actualización cancelada.');
                    return;
                  }
                  
                  // Llamada al controlador con la dirección completa
                  final ok = await controller.actualizarPerfil(
                    nuevaDireccion: direccionCompleta,
                    nuevoTelefono: telefonoCtrl.text,
                  );

                  if (ok) {
                    NotificationService.showSuccess("Perfil actualizado correctamente");
                  }
                  
                } : null,
                
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
