class CursoResponse {
  final String codigo;
  final String nombre;
  final int creditos;
  final String? horario;
  final String? profesor;
  final String? aula;
  final String estado; // Ej: 'Activo', 'Aprobado', 'Reprobado'
  final double? notaFinal;
  final String periodo;

  CursoResponse({
    required this.codigo,
    required this.nombre,
    required this.creditos,
    this.horario,
    this.profesor,
    this.aula,
    required this.estado,
    this.notaFinal,
    required this.periodo,
  });

  factory CursoResponse.fromJson(Map<String, dynamic> json) {
    return CursoResponse(
      codigo: json['codigo']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      creditos: json['creditos'] ?? 0,
      horario: json['horario']?.toString(),
      profesor: json['profesor']?.toString(),
      aula: json['aula']?.toString(),
      estado: json['estado']?.toString() ?? 'Desconocido',
      notaFinal: json['notaFinal'] != null 
          ? double.tryParse(json['notaFinal'].toString()) 
          : null,
      periodo: json['periodo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'creditos': creditos,
      'horario': horario,
      'profesor': profesor,
      'aula': aula,
      'estado': estado,
      'notaFinal': notaFinal,
      'periodo': periodo,
    };
  }
}
