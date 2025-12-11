import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/nueva_prematricula_response.dart';
import 'package:modulo_mobil/services/prematricula_service.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

// ----------------------------------------------------------------------
// 1. CONTROLADOR (Lógica de la Nueva Prematrícula)
// ----------------------------------------------------------------------
class NuevaPrematriculaController extends GetxController {
  // Servicio de prematrícula + login
  final PrematriculaService prematriculaService = PrematriculaService();
  final LoginController loginController = Get.find<LoginController>();

  // Datos de prueba para los Dropdowns (por ahora solo nombres)
  final List<String> carreras = [
    'Ingeniería de Sistemas',
    'Contabilidad',
    'Administración de Empresas',
  ];

  // Map Carrera -> Lista de cursos
  final Map<String, List<String>> cursosPorCarrera = {
    'Ingeniería de Sistemas': [
      'Programación I',
      'Estructura de Datos',
      'Bases de Datos',
    ],
    'Contabilidad': [
      'Contabilidad General',
      'Finanzas I',
      'Auditoría',
    ],
    'Administración de Empresas': [
      'Gestión Empresarial',
      'Marketing',
      'Recursos Humanos',
    ],
  };

  // Variables reactivas para el formulario
  var carreraSeleccionada = Rxn<String>();
  var cursoSeleccionado = Rxn<String>();
  final periodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Estado de envío (loading del botón)
  var enviando = false.obs;

  void limpiarFormulario() {
    carreraSeleccionada.value = null;
    cursoSeleccionado.value = null;
    periodoController.clear();
    observacionesController.clear();
  }

  // Lógica para actualizar los cursos cuando cambia la carrera
  void actualizarCurso(String? nuevaCarrera) {
    carreraSeleccionada.value = nuevaCarrera;
    cursoSeleccionado.value = null; // Resetear el curso al cambiar la carrera
  }

  // Enviar prematrícula al backend
  Future<void> enviarPrematricula() async {
    // Validación de formulario y dropdowns
    if (!(formKey.currentState?.validate() ?? false) ||
        carreraSeleccionada.value == null ||
        cursoSeleccionado.value == null) {
      Get.snackbar(
        '⚠️ Error de Formulario',
        'Por favor, selecciona Carrera y Curso, y completa los campos obligatorios.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Obtener usuario logueado
    final usuario = loginController.usuarioActual.value;
    if (usuario == null) {
      Get.snackbar(
        'Error',
        'No se encontró información del usuario. Inicia sesión nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // TODO: Ajustar a IDs reales de tu backend
    final String carrera = carreraSeleccionada.value!;
    final String curso = cursoSeleccionado.value!;

    // EJEMPLO: usar índice como ID (cámbialo por tus IDs reales de BD)
    final int idCarrera = carreras.indexOf(carrera) + 1; // TODO: reemplazar
    final List<String> cursosDeCarrera = cursosPorCarrera[carrera] ?? [];
    final int idCurso = cursosDeCarrera.indexOf(curso) + 1; // TODO: reemplazar

    // Periodo: el backend espera iD_Periodo (int)
    // Por ahora intentamos parsear el texto
    final String periodoTexto = periodoController.text.trim();
    int idPeriodo;
    try {
      idPeriodo = int.parse(periodoTexto); // TODO: adapta a tu esquema
    } catch (_) {
      Get.snackbar(
        'Error',
        'El período debe ser un número válido (ajusta esta lógica según tu API).',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    // ID de estudiante: adaptar según tu modelo
    int idEstudiante;
    try {
      idEstudiante = int.parse(usuario.identificacion);
    } catch (_) {
      Get.snackbar(
        'Error',
        'No se pudo obtener el ID del estudiante desde la identificación.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    final request = PrematriculaRequest(
      idPrematricula: 0,          // siempre 0 al crear
      idEstudiante: idEstudiante, // iD_Estudiante
      idCarrera: idCarrera,       // iD_Carrera
      idCurso: idCurso,           // iD_Curso
      observaciones: observacionesController.text.trim(),
      idPeriodo: idPeriodo,       // iD_Periodo
    );

    enviando.value = true;
    final ok = await prematriculaService.crearPrematricula(request);
    enviando.value = false;

    if (ok) {
      Get.snackbar(
        '✅ Solicitud Enviada',
        'Tu solicitud de pre-matrícula para $curso ha sido registrada con éxito.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      limpiarFormulario();
    } else {
      Get.snackbar(
        '❌ Error',
        'No se pudo registrar la pre-matrícula. Inténtalo de nuevo más tarde.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
      validator: validator ??
          (value) {
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

                final cursos = selectedCarrera != null
                    ? controller.cursosPorCarrera[selectedCarrera] ?? <String>[]
                    : <String>[];

                return _buildDropdownField(
                  label: "Seleccionar Curso",
                  value: controller.cursoSeleccionado,
                  items: cursos,
                  onChanged: (newValue) =>
                      controller.cursoSeleccionado.value = newValue,
                  isDisabled: selectedCarrera == null,
                );
              }),
              const SizedBox(height: 16),

              // --- CAMPO PERÍODO (TextField) ---
              _buildTextField(
                controller: controller.periodoController,
                label: "Período (Ej: 2026-1 o ID numérico)",
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
              Obx(() {
                final isLoading = controller.enviando.value;
                return ElevatedButton.icon(
                  onPressed:
                      isLoading ? null : () => controller.enviarPrematricula(),
                  icon: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    isLoading ? "Enviando..." : "Realizar Prematrícula",
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
