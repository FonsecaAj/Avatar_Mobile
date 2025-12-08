class CursoResponse {
  final String codigoCurso;
  final String nombre;

  CursoResponse({
    required this.codigoCurso,
    required this.nombre,
  });

  factory CursoResponse.fromJson(Map<String, dynamic> json) {
    return CursoResponse(
      codigoCurso: json["codigo_Curso"] ?? "",
      nombre: json["nombre"] ?? "",
    );
  }
}
