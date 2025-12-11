class PeriodoMatricula {
  final int idPeriodo;
  final String descripcion;
  final bool esActivo;

  PeriodoMatricula({
    required this.idPeriodo,
    required this.descripcion,
    required this.esActivo,
  });

  factory PeriodoMatricula.fromJson(Map<String, dynamic> json) {
    return PeriodoMatricula(
      idPeriodo: json['id_Periodo'] ?? json['idPeriodo'] ?? json['id'],
      descripcion: json['descripcion'] ?? json['nombre'] ?? '',
      esActivo: json['esActivo'] ?? json['es_Activo'] ?? false,
    );
  }
}

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
    return CursoMatricula(
      idCurso: json['id_Curso'] ?? json['idCurso'] ?? json['id'],
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? json['descripcion'] ?? '',
    );
  }
}

class GrupoMatricula {
  final int idGrupo;
  final int idCurso;
  final int idPeriodo;
  final String nombreGrupo;
  final String? horario;
  final String? profesor;

  GrupoMatricula({
    required this.idGrupo,
    required this.idCurso,
    required this.idPeriodo,
    required this.nombreGrupo,
    this.horario,
    this.profesor,
  });

  factory GrupoMatricula.fromJson(Map<String, dynamic> json) {
    return GrupoMatricula(
      idGrupo: json['id_Grupo'] ?? json['idGrupo'] ?? json['id'],
      idCurso: json['id_Curso'] ?? json['idCurso'],
      idPeriodo: json['id_Periodo'] ?? json['idPeriodo'],
      nombreGrupo: json['nombreGrupo'] ?? json['grupo'] ?? '',
      horario: json['horario'],
      profesor: json['profesor'],
    );
  }
}

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
    final periodosJson = (json['periodos'] ?? json['Periodos'] ?? []) as List;
    final cursosJson = (json['cursos'] ?? json['Cursos'] ?? []) as List;
    final gruposJson = (json['grupos'] ?? json['Grupos'] ?? []) as List;

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
