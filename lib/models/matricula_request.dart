class MatriculaRequest {
  final String identificacion;
  final int idCurso;
  final int idGrupo;
  final int idPeriodo;

  MatriculaRequest({
    required this.identificacion,
    required this.idCurso,
    required this.idGrupo,
    required this.idPeriodo,
  });

  Map<String, dynamic> toJson() {
    return {
      "Identificacion": identificacion,
      "ID_Curso": idCurso,
      "ID_Grupo": idGrupo,
      "ID_Periodo": idPeriodo,
    };
  }
}
