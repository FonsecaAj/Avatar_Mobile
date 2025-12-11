import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/models/matricula_request.dart';
import 'package:modulo_mobil/models/matricula_lookups.dart';
import 'package:modulo_mobil/services/matricula_service.dart';

class MatriculaNuevaController extends GetxController {
  final MatriculaApiService _service;

  MatriculaNuevaController({MatriculaApiService? service})
    : _service = service ?? MatriculaApiService();

  final cargando = false.obs;
  final error = ''.obs;

  // listas de lookups
  final periodos = <PeriodoMatricula>[].obs;
  final cursos = <CursoMatricula>[].obs;
  final gruposTodos = <GrupoMatricula>[].obs;
  final gruposFiltrados = <GrupoMatricula>[].obs;

  // selección actual
  final periodoSeleccionado = Rx<PeriodoMatricula?>(null);
  final cursoSeleccionado = Rx<CursoMatricula?>(null);
  final grupoSeleccionado = Rx<GrupoMatricula?>(null);

  late String _identificacion;

  @override
  void onInit() {
    super.onInit();
    _cargarIdentificacionYLookups();
  }

  Future<void> _cargarIdentificacionYLookups() async {
    try {
      cargando.value = true;
      error.value = '';

      final loginCtrl = Get.find<LoginController>();
      _identificacion = loginCtrl.usuarioActual.value?.identificacion ?? '';

      if (_identificacion.isEmpty) {
        error.value = 'No se pudo obtener la identificación del usuario.';
        return;
      }

      final lookups = await _service.obtenerLookups();
      if (lookups == null) {
        error.value = 'No se pudieron cargar los catálogos de matrícula.';
        return;
      }

      periodos.assignAll(lookups.periodos);
      cursos.assignAll(lookups.cursos);
      gruposTodos.assignAll(lookups.grupos);

      // seleccionar automáticamente el periodo activo si viene marcado
      final activo = lookups.periodos.firstWhere(
        (p) => p.esActivo,
        orElse: () => lookups.periodos.isNotEmpty
            ? lookups.periodos.first
            : PeriodoMatricula(
                idPeriodo: 0,
                descripcion: 'Sin periodos',
                esActivo: false,
              ),
      );

      if (activo.idPeriodo != 0) {
        periodoSeleccionado.value = activo;
      }

      _filtrarGrupos();
    } catch (e) {
      error.value = 'Error cargando lookups: $e';
    } finally {
      cargando.value = false;
    }
  }

  void seleccionarPeriodo(PeriodoMatricula periodo) {
    periodoSeleccionado.value = periodo;
    _filtrarGrupos();
  }

  void seleccionarCurso(CursoMatricula curso) {
    cursoSeleccionado.value = curso;
    _filtrarGrupos();
  }

  void seleccionarGrupo(GrupoMatricula grupo) {
    grupoSeleccionado.value = grupo;
  }

  void _filtrarGrupos() {
    if (cursoSeleccionado.value == null || periodoSeleccionado.value == null) {
      gruposFiltrados.clear();
      return;
    }

    final idCurso = cursoSeleccionado.value!.idCurso;
    final idPeriodo = periodoSeleccionado.value!.idPeriodo;

    gruposFiltrados.assignAll(
      gruposTodos.where(
        (g) => g.idCurso == idCurso && g.idPeriodo == idPeriodo,
      ),
    );

    if (!gruposFiltrados.contains(grupoSeleccionado.value)) {
      grupoSeleccionado.value = null;
    }
  }

  Future<bool> confirmarMatricula() async {
    if (_identificacion.isEmpty) {
      error.value = 'No se pudo obtener la identificación del usuario.';
      return false;
    }
    if (cursoSeleccionado.value == null ||
        grupoSeleccionado.value == null ||
        periodoSeleccionado.value == null) {
      error.value = 'Debes seleccionar curso, grupo y periodo.';
      return false;
    }

    cargando.value = true;
    error.value = '';

    final request = MatriculaRequest(
      identificacion: _identificacion,
      idCurso: cursoSeleccionado.value!.idCurso,
      idGrupo: grupoSeleccionado.value!.idGrupo,
      idPeriodo: periodoSeleccionado.value!.idPeriodo,
    );

    final ok = await _service.crearMatricula(request);

    if (!ok) {
      error.value = 'No se pudo completar la matrícula.';
    }

    cargando.value = false;
    return ok;
  }
}
