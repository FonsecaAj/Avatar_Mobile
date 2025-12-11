// lib/models/curso_response.dart

class CursoResponse {
  final int idCurso;
  final String codigoCurso;
  final String nombre;
  final String grupo;
  final String profesor;
  final String horario;
  final String periodo;
  final bool esPeriodoActual;

  CursoResponse({
    required this.idCurso,
    required this.codigoCurso,
    required this.nombre,
    required this.grupo,
    required this.profesor,
    required this.horario,
    required this.periodo,
    required this.esPeriodoActual,
  });

  factory CursoResponse.fromJson(Map<String, dynamic> json) {
    int _leerInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    bool _leerBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        final v = value.toLowerCase();
        return v == 'true' || v == '1' || v == 'yes';
      }
      return false;
    }

    final id = _leerInt(
      json['iD_Curso'] ??
          json['ID_Curso'] ??
          json['id_Curso'] ??
          json['idCurso'] ??
          json['IdCurso'],
    );

    final cod =
        (json['codigo_Curso'] ??
                json['Codigo_Curso'] ??
                json['codigoCurso'] ??
                json['CodigoCurso'] ??
                json['identificador'] ??
                '')
            .toString();

    final nom =
        (json['nombre'] ??
                json['Nombre'] ??
                json['nombre_Curso'] ??
                json['Nombre_Curso'] ??
                '')
            .toString();

    final grp =
        (json['grupo'] ??
                json['Grupo'] ??
                json['nombre_Grupo'] ??
                json['Nombre_Grupo'] ??
                '')
            .toString();

    final prof = (json['profesor'] ?? json['Profesor'] ?? '').toString();
    final hor = (json['horario'] ?? json['Horario'] ?? '').toString();
    final per = (json['periodo'] ?? json['Periodo'] ?? '').toString();

    final esActual = _leerBool(
      json['esPeriodoActual'] ?? json['EsPeriodoActual'],
    );

    return CursoResponse(
      idCurso: id,
      codigoCurso: cod,
      nombre: nom,
      grupo: grp,
      profesor: prof,
      horario: hor,
      periodo: per,
      esPeriodoActual: esActual,
    );
  }
}
