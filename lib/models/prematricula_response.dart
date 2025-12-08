class PrematriculaResponse {
  final String identificacion;
  final String nombreCompleto;
  final String carreraEstudiante;
  final String observaciones;
  final String nombreCarrera;
  final String nombreCurso;
  final String codigoCurso;
  final int anio;
  final int numeroPeriodo;
  final String fechaInicio;
  final String fechaFin;

  PrematriculaResponse({
    required this.identificacion,
    required this.nombreCompleto,
    required this.carreraEstudiante,
    required this.observaciones,
    required this.nombreCarrera,
    required this.nombreCurso,
    required this.codigoCurso,
    required this.anio,
    required this.numeroPeriodo,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory PrematriculaResponse.fromJson(Map<String, dynamic> json) {
    return PrematriculaResponse(
      identificacion: json["identificacion"],
      nombreCompleto: json["nombre_Completo"],
      carreraEstudiante: json["carrera_Estudiante"],
      observaciones: json["observaciones"],
      nombreCarrera: json["nombre_Carrera"],
      nombreCurso: json["nombre_Curso"],
      codigoCurso: json["codigo_Curso"],
      anio: json["año"],
      numeroPeriodo: json["numero_Periodo"],
      fechaInicio: json["fecha_Inicio"],
      fechaFin: json["fecha_Fin"],
    );
  }
}
