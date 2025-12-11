class ApiResponse<T> {
  final int statusCode;
  final String message;
  final List<T> responseObject;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.responseObject,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      responseObject: (json['responseObject'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

// Modelo para Provincia
class Provincia {
  final int idProvincia;
  final String nombreProvincia;

  Provincia({
    required this.idProvincia,
    required this.nombreProvincia,
  });

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      idProvincia: json['iD_Provincia'],
      nombreProvincia: (json['nombre_Provincia'] as String).trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iD_Provincia': idProvincia,
      'nombre_Provincia': nombreProvincia,
    };
  }

  // IMPORTANTE: Necesario para que funcione el dropdown
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Provincia &&
          runtimeType == other.runtimeType &&
          idProvincia == other.idProvincia;

  @override
  int get hashCode => idProvincia.hashCode;

  @override
  String toString() => 'Provincia{id: $idProvincia, nombre: $nombreProvincia}';
}

// Modelo para Cantón
class Canton {
  final int idCanton;
  final int idProvincia;
  final String nombreCanton;

  Canton({
    required this.idCanton,
    required this.idProvincia,
    required this.nombreCanton,
  });

  factory Canton.fromJson(Map<String, dynamic> json) {
    return Canton(
      idCanton: json['iD_Canton'],
      idProvincia: json['iD_Provincia'],
      nombreCanton: (json['nombre_Canton'] as String).trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iD_Canton': idCanton,
      'iD_Provincia': idProvincia,
      'nombre_Canton': nombreCanton,
    };
  }

  // IMPORTANTE: Necesario para que funcione el dropdown
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Canton &&
          runtimeType == other.runtimeType &&
          idCanton == other.idCanton;

  @override
  int get hashCode => idCanton.hashCode;

  @override
  String toString() => 'Canton{id: $idCanton, nombre: $nombreCanton}';
}

// Modelo para Distrito
class Distrito {
  final int idDistrito;
  final int idProvincia;
  final int idCanton;
  final String nombreDistrito;

  Distrito({
    required this.idDistrito,
    required this.idProvincia,
    required this.idCanton,
    required this.nombreDistrito,
  });

  factory Distrito.fromJson(Map<String, dynamic> json) {
    return Distrito(
      idDistrito: json['iD_Distrito'],
      idProvincia: json['iD_Provincia'],
      idCanton: json['iD_Canton'],
      nombreDistrito: (json['nombre_Distrito'] as String).trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iD_Distrito': idDistrito,
      'iD_Provincia': idProvincia,
      'iD_Canton': idCanton,
      'nombre_Distrito': nombreDistrito,
    };
  }

  // IMPORTANTE: Necesario para que funcione el dropdown
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Distrito &&
          runtimeType == other.runtimeType &&
          idDistrito == other.idDistrito;

  @override
  int get hashCode => idDistrito.hashCode;

  @override
  String toString() => 'Distrito{id: $idDistrito, nombre: $nombreDistrito}';
}
