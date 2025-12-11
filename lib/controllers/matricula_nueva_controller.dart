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

  final periodos = <PeriodoMatricula>[].obs;
  final cursos = <CursoMatricula>[].obs;
  final gruposTodos = <GrupoMatricula>[].obs;
  final gruposFiltrados = <GrupoMatricula>[].obs;

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

      _refrescarGrupos();
    } catch (e) {
      error.value = 'Error cargando lookups: $e';
    } finally {
      cargando.value = false;
    }
  }

  void seleccionarPeriodo(PeriodoMatricula periodo) {
    periodoSeleccionado.value = periodo;
    _refrescarGrupos();
  }

  void seleccionarCurso(CursoMatricula curso) {
    cursoSeleccionado.value = curso;
    _refrescarGrupos();
  }

  void seleccionarGrupo(GrupoMatricula grupo) {
    grupoSeleccionado.value = grupo;
  }

  void _refrescarGrupos() {
    final curso = cursoSeleccionado.value;
    final periodo = periodoSeleccionado.value;

    if (curso == null) {
      gruposFiltrados.clear();
      print('REFRESCAR GRUPOS: sin curso seleccionado');
      return;
    }

    var gruposCurso = gruposTodos
        .where((g) => g.idCurso == curso.idCurso)
        .toList();

    if (periodo != null && gruposCurso.any((g) => g.idPeriodo != 0)) {
      gruposCurso = gruposCurso
          .where((g) => g.idPeriodo == periodo.idPeriodo)
          .toList();
    }

    gruposFiltrados.assignAll(gruposCurso);

    print(
      'REFRESCAR GRUPOS: '
      'curso=${curso.idCurso}, '
      'periodo=${periodo?.idPeriodo}, '
      'gruposFiltrados=${gruposCurso.length}',
    );
  }

  // ================== Confirmar matrícula ==================
  Future<bool> confirmarMatricula() async {
    if (_identificacion.isEmpty) {
      error.value = 'No se pudo obtener la identificación del usuario.';
      return false;
    }
    if (cursoSeleccionado.value == null ||
        grupoSeleccionado.value == null ||
        periodoSeleccionado.value == null) {
      error.value = 'Debes seleccionar curso, grupo y período.';
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

    print(
      'DEBUG MATRICULA SELECCIONADA => identificacion=$_identificacion, curso=${request.idCurso}, grupo=${request.idGrupo}, periodo=${request.idPeriodo}',
    );

    try {
      await _service.crearMatricula(request); // lanza Exception si falla
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      error.value = msg;
      print('ERROR confirmarMatricula: $msg');
      return false;
    } finally {
      cargando.value = false;
    }
  }
}
