class NotificacionEmailRequest {
  final String email;
  final String asunto;
  final String mensaje;

  NotificacionEmailRequest({
    required this.email,
    required this.asunto,
    required this.mensaje,
  });

  factory NotificacionEmailRequest.fromJson(Map<String, dynamic> json) {
    return NotificacionEmailRequest(
      email: json['email'] as String,
      asunto: json['asunto'] as String,
      mensaje: json['mensaje'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'asunto': asunto,
      'mensaje': mensaje,
    };
  }
}
