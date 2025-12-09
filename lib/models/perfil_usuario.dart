class PerfilUsuario {
  final String email;
  final String nombre;
  final String direccion;
  final String telefono;

  PerfilUsuario({
    required this.email,
    required this.nombre,
    required this.direccion,
    required this.telefono,
  });

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "direccion": direccion,
        "telefono": telefono,
      };
}
