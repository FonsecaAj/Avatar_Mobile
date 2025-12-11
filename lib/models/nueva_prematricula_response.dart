class PrematriculaRequest {
  final int idPrematricula;
  final int idEstudiante;
  final int idCarrera;
  final int idCurso;
  final String observaciones;
  final int idPeriodo;

  PrematriculaRequest({
    required this.idPrematricula,
    required this.idEstudiante,
    required this.idCarrera,
    required this.idCurso,
    required this.observaciones,
    required this.idPeriodo,
  });

  factory PrematriculaRequest.fromJson(Map<String, dynamic> json) {
    return PrematriculaRequest(
      idPrematricula: json['iD_Prematricula'] as int,
      idEstudiante:  json['iD_Estudiante']  as int,
      idCarrera:     json['iD_Carrera']     as int,
      idCurso:       json['iD_Curso']       as int,
      observaciones: json['observaciones']  as String,
      idPeriodo:     json['iD_Periodo']     as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iD_Prematricula': idPrematricula,
      'iD_Estudiante':   idEstudiante,
      'iD_Carrera':      idCarrera,
      'iD_Curso':        idCurso,
      'observaciones':   observaciones,
      'iD_Periodo':      idPeriodo,
    };
  }
}
