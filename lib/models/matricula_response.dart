import 'dart:convert';

// Clase que representa un único curso/registro dentro de la matrícula.
class MatriculaResponse {
  final String carreraEstudiante;
  final DateTime fechaMatricula;
  final String nombreGrupo;
  final String nombreCurso;
  final String codigoCurso;
  final String periodoActual;

  MatriculaResponse({
    required this.carreraEstudiante,
    required this.fechaMatricula,
    required this.nombreGrupo,
    required this.nombreCurso,
    required this.codigoCurso,
    required this.periodoActual,
  });

  // Método de fábrica para crear una instancia desde un mapa (JSON)
  factory MatriculaResponse.fromJson(Map<String, dynamic> json) {
    return MatriculaResponse(
      // Usamos el operador '??' para asegurar que si el valor es null, usemos una cadena vacía o un valor por defecto.
      // Note que la clave 'carrera_Estudiante' se convierte a camelCase en la propiedad de Dart.
      carreraEstudiante: json['carrera_Estudiante'] as String? ?? '',
      
      // Convertimos la cadena de fecha a un objeto DateTime
      fechaMatricula: DateTime.parse(json['fecha_Matricula'] as String),
      
      nombreGrupo: json['nombre_Grupo'] as String? ?? '',
      nombreCurso: json['nombre_Curso'] as String? ?? '',
      codigoCurso: json['codigo_Curso'] as String? ?? '',
      periodoActual: json['periodo_Actual'] as String? ?? '',
    );
  }

  // Opcional: Método para convertir la instancia a un mapa (si lo necesitaras)
  Map<String, dynamic> toJson() => {
    'carrera_Estudiante': carreraEstudiante,
    'fecha_Matricula': fechaMatricula.toIso8601String(),
    'nombre_Grupo': nombreGrupo,
    'nombre_Curso': nombreCurso,
    'codigo_Curso': codigoCurso,
    'periodo_Actual': periodoActual,
  };
}
