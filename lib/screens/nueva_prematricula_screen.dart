import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Asegúrate de que esta ruta sea correcta en tu proyecto
import 'package:modulo_mobil/widgets/main_layout.dart'; 

// ----------------------------------------------------------------------
// 1. CONTROLADOR (Lógica de la Nueva Prematrícula)
// ----------------------------------------------------------------------
class NuevaPrematriculaController extends GetxController {
  // Datos de prueba para los Dropdowns
  final List<String> carreras = ['Ingeniería de Sistemas', 'Contabilidad', 'Administración de Empresas'];
  // NOTA: Se mantiene la tipificación correcta Map<String, List<String>>
  final Map<String, List<String>> cursosPorCarrera = {
    'Ingeniería de Sistemas': ['Programación I', 'Estructura de Datos', 'Bases de Datos'],
    'Contabilidad': ['Contabilidad General', 'Finanzas I', 'Auditoría'],
    'Administración de Empresas': ['Gestión Empresarial', 'Marketing', 'Recursos Humanos'],
  };

  // Variables reactivas para el formulario
  var carreraSeleccionada = Rxn<String>();
  var cursoSeleccionado = Rxn<String>();
  final periodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void limpiarFormulario() {
    carreraSeleccionada.value = null;
    cursoSeleccionado.value = null;
    periodoController.clear();
    observacionesController.clear();
  }

  void enviarPrematricula() {
    // Se valida el formulario y que los dropdowns tengan un valor seleccionado
    if (formKey.currentState!.validate() && carreraSeleccionada.value != null && cursoSeleccionado.value != null) {
      
      // Mostrar mensaje de confirmación
      Get.snackbar(
        '✅ Solicitud Enviada',
        'Tu solicitud de pre-matrícula para ${cursoSeleccionado.value} ha sido registrada con éxito.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Limpiar formulario después del envío
      limpiarFormulario();
    } else {
      Get.snackbar(
        '⚠️ Error de Formulario',
        'Por favor, selecciona Carrera y Curso, y completa los campos obligatorios.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Lógica para actualizar los cursos cuando cambia la carrera
  void actualizarCurso(String? nuevaCarrera) {
    carreraSeleccionada.value = nuevaCarrera;
    cursoSeleccionado.value = null; // Resetear el curso al cambiar la carrera
  }
}

// ----------------------------------------------------------------------
// 2. WIDGET (Diseño de la Nueva Prematrícula)
// ----------------------------------------------------------------------
class NuevaPrematriculaScreen extends StatelessWidget {
  const NuevaPrematriculaScreen({super.key});

  // --- Widgets Auxiliares para el Estilo ---
  Widget _buildDropdownField({
    required String label,
    required Rxn<String> value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isDisabled = false,
  }) {
    return Obx(() => DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        filled: isDisabled,
        fillColor: isDisabled ? Colors.grey[200] : null,
      ),
      value: value.value,
      hint: Text(label),
      isExpanded: true,
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: isDisabled ? null : onChanged,
      validator: (val) {
        if (val == null) {
          return 'Debes seleccionar $label.';
        }
        return null;
      },
    ));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
      validator: validator ?? (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo ($label) es obligatorio.';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NuevaPrematriculaController());

    return MainLayout(
      title: "Nueva Prematrícula",
      currentIndex: 1, 
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SELECCIÓN DE CARRERA (Dropdown) ---
              _buildDropdownField(
                label: "Seleccionar Carrera",
                value: controller.carreraSeleccionada,
                items: controller.carreras,
                onChanged: controller.actualizarCurso,
              ),
              const SizedBox(height: 16),

              // --- SELECCIÓN DE CURSO (Dropdown - Depende de la Carrera) ---
              Obx(() {
                final selectedCarrera = controller.carreraSeleccionada.value;
                
                // CORRECCIÓN del error: Asegura que el tipo sea List<String>
                final cursos = selectedCarrera != null 
                    ? controller.cursosPorCarrera[selectedCarrera] ?? <String>[] 
                    : <String>[];

                return _buildDropdownField(
                  label: "Seleccionar Curso",
                  value: controller.cursoSeleccionado,
                  items: cursos,
                  onChanged: (newValue) => controller.cursoSeleccionado.value = newValue,
                  isDisabled: selectedCarrera == null, 
                );
              }),
              const SizedBox(height: 16),

              // --- CAMPO PERÍODO (TextField) ---
              _buildTextField(
                controller: controller.periodoController,
                label: "Período (Ej: 2026-1)",
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),

              // --- CAMPO OBSERVACIONES (TextField) ---
              _buildTextField(
                controller: controller.observacionesController,
                label: "Observaciones / Notas Adicionales",
                icon: Icons.notes,
                maxLines: 4,
                isRequired: false, // Las observaciones son opcionales
              ),
              const SizedBox(height: 24),

              // --- BOTÓN DE ENVÍO ---
              ElevatedButton.icon(
                onPressed: controller.enviarPrematricula,
                icon: const Icon(Icons.send),
                label: const Text(
                  "Realizar Prematrícula",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  // Utiliza el color primario de tu tema para consistencia
                  backgroundColor: Theme.of(context).primaryColor, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}