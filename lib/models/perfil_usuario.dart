class PerfilUsuario {
  
  // Campos a mostrar (incluyendo los nuevos)
  final String email;
  final String nombre;
  final String tipoIdentificacion; // Usamos camelCase en Dart por convención
  final String identificacion;
  
  // Campos que pueden ser nulos en la respuesta y son editables
  final String direccion;
  final String telefono;

  // 1. Constructor
  PerfilUsuario({
    required this.email,
    required this.nombre,
    required this.tipoIdentificacion,
    required this.identificacion,
    required this.direccion,
    required this.telefono,
  });

  // 2. Método de fábrica para crear la instancia desde el JSON (API GET response)
  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    // Usamos 'tipo_Identificacion' para coincidir con la respuesta del API,
    // pero lo almacenamos como 'tipoIdentificacion' en la clase.
    return PerfilUsuario(
      email: json['email'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      tipoIdentificacion: json['tipo_Identificacion'] as String? ?? '',
      identificacion: json['identificacion'] as String? ?? '',
      
      // Manejamos 'null' para 'direccion' y 'telefono'
      direccion: json['direccion'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
    );
  }

  // 3. Método copyWith (ESENCIAL para el PerfilController y la inmutabilidad)
  // Permite crear una copia del objeto con valores específicos modificados.
  PerfilUsuario copyWith({
    String? email,
    String? nombre,
    String? tipoIdentificacion,
    String? identificacion,
    String? direccion,
    String? telefono,
  }) {
    return PerfilUsuario(
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      tipoIdentificacion: tipoIdentificacion ?? this.tipoIdentificacion,
      identificacion: identificacion ?? this.identificacion,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
    );
  }

  // 4. Método para convertir el modelo a JSON (API PUT/POST request body)
  // Incluye el email, ya que es requerido por el endpoint de edición
  Map<String, dynamic> toJson() => {
    "email": email, // Requerido para la edición
    "direccion": direccion,
    "telefono": telefono,
  };
}