class RefreshResponse {
  final DateTime expiresIn;
  final String accessToken;
  final String refreshToken;

  RefreshResponse({
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      expiresIn: DateTime.parse(
        json['expires_in']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expires_in': expiresIn.toIso8601String(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
