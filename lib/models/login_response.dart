class LoginResponse {
  final DateTime expiresIn;
  final String accessToken;
  final String refreshToken;
  final String usuarioId;

  LoginResponse({
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
    required this.usuarioId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      expiresIn: DateTime.parse(json['expires_in']?.toString() ?? ''),
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
      usuarioId: json['usuarioID']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expires_in': expiresIn.toIso8601String(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'usuarioID': usuarioId,
    };
  }
}
