// lib/models/matricula_lookups.dart

// ===== Helper genérico para convertir cualquier cosa a int =====
int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// ======================= PERIODO =======================

class PeriodoMatricula {
  final int idPeriodo;
  final String descripcion;
  final bool esActivo;

  PeriodoMatricula({
    required this.idPeriodo,
    required this.descripcion,
    this.esActivo = false,
  });

  factory PeriodoMatricula.fromJson(Map<String, dynamic> json) {
    final int id = _toInt(
      json['iD_Periodo'] ??
          json['ID_Periodo'] ??
          json['id_Periodo'] ??
          json['idPeriodo'] ??
          json['IdPeriodo'],
    );

    final int anio = _toInt(json['año'] ?? json['anio'] ?? json['Anio']);
    final int numPeriodo = _toInt(
      json['numero_Periodo'] ?? json['Numero_Periodo'],
    );

    String desc;
    if (anio != 0 && numPeriodo != 0) {
      desc = 'Año $anio - Periodo $numPeriodo';
    } else {
      desc =
          (json['descripcion'] ??
                  json['Descripcion'] ??
                  json['nombre'] ??
                  json['Nombre'] ??
                  '')
              .toString();
    }

    // No viene esActivo en el JSON, así que queda false por defecto
    final bool activo =
        (json['esActivo'] ?? json['EsActivo'] ?? json['activo'] ?? false) ==
        true;

    return PeriodoMatricula(idPeriodo: id, descripcion: desc, esActivo: activo);
  }
}

// ======================= CURSO =======================

class CursoMatricula {
  final int idCurso;
  final String codigo;
  final String nombre;

  CursoMatricula({
    required this.idCurso,
    required this.codigo,
    required this.nombre,
  });

  factory CursoMatricula.fromJson(Map<String, dynamic> json) {
    final int id = _toInt(
      json['iD_Curso'] ?? // 👈 EXACTO COMO VIENE EN EL JSON
          json['ID_Curso'] ??
          json['id_Curso'] ??
          json['idCurso'] ??
          json['IdCurso'],
    );

    final String cod =
        (json['codigo_Curso'] ??
                json['codigo'] ??
                json['Codigo'] ??
                json['codigoCurso'] ??
                json['CodigoCurso'] ??
                '')
            .toString();

    final String nom =
        (json['nombre_Curso'] ??
                json['nombre'] ??
                json['Nombre'] ??
                json['nombreCurso'] ??
                json['NombreCurso'] ??
                '')
            .toString();

    final safeCodigo = cod.isEmpty ? 'Curso $id' : cod;
    final safeNombre = nom;

    return CursoMatricula(idCurso: id, codigo: safeCodigo, nombre: safeNombre);
  }
}

// ======================= GRUPO =======================

class GrupoMatricula {
  final int idGrupo;
  final int idCurso;
  final int
  idPeriodo; // No viene en JSON, será 0, pero lo dejamos por compatibilidad
  final String nombreGrupo;
  final String nombreCurso;
  final int cupoMaximo;
  final int cupoDisponible;

  GrupoMatricula({
    required this.idGrupo,
    required this.idCurso,
    required this.idPeriodo,
    required this.nombreGrupo,
    required this.nombreCurso,
    required this.cupoMaximo,
    required this.cupoDisponible,
  });

  factory GrupoMatricula.fromJson(Map<String, dynamic> json) {
    final int idG = _toInt(
      json['iD_Grupo'] ??
          json['ID_Grupo'] ??
          json['id_Grupo'] ??
          json['idGrupo'] ??
          json['IdGrupo'],
    );

    final int idC = _toInt(
      json['iD_Curso'] ??
          json['ID_Curso'] ??
          json['id_Curso'] ??
          json['idCurso'] ??
          json['IdCurso'],
    );

    // OJO: el JSON de grupos NO trae periodo, así que será 0 siempre
    final int idP = _toInt(
      json['iD_Periodo'] ??
          json['ID_Periodo'] ??
          json['id_Periodo'] ??
          json['idPeriodo'] ??
          json['IdPeriodo'],
    );

    final String nomGrupo =
        (json['nombre_Grupo'] ??
                json['nombreGrupo'] ??
                json['Nombre_Grupo'] ??
                json['Grupo'] ??
                json['grupo'] ??
                '')
            .toString();

    final String nomCurso =
        (json['nombre_Curso'] ??
                json['nombreCurso'] ??
                json['Nombre_Curso'] ??
                json['NombreCurso'] ??
                '')
            .toString();

    final int cupoMax = _toInt(json['cupo_Maximo'] ?? json['cupoMaximo']);
    final int cupoDisp = _toInt(
      json['cupo_Disponible'] ?? json['cupoDisponible'],
    );

    return GrupoMatricula(
      idGrupo: idG,
      idCurso: idC,
      idPeriodo: idP,
      nombreGrupo: nomGrupo,
      nombreCurso: nomCurso,
      cupoMaximo: cupoMax,
      cupoDisponible: cupoDisp,
    );
  }
}

// ======================= ROOT DTO =======================

class MatriculaLookups {
  final List<PeriodoMatricula> periodos;
  final List<CursoMatricula> cursos;
  final List<GrupoMatricula> grupos;

  MatriculaLookups({
    required this.periodos,
    required this.cursos,
    required this.grupos,
  });

  factory MatriculaLookups.fromJson(Map<String, dynamic> json) {
    final periodosJson =
        (json['periodos'] ?? json['Periodos'] ?? []) as List<dynamic>;
    final cursosJson =
        (json['cursos'] ?? json['Cursos'] ?? []) as List<dynamic>;
    final gruposJson =
        (json['grupos'] ?? json['Grupos'] ?? []) as List<dynamic>;

    return MatriculaLookups(
      periodos: periodosJson
          .map((e) => PeriodoMatricula.fromJson(e as Map<String, dynamic>))
          .toList(),
      cursos: cursosJson
          .map((e) => CursoMatricula.fromJson(e as Map<String, dynamic>))
          .toList(),
      grupos: gruposJson
          .map((e) => GrupoMatricula.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
