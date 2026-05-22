class SwileModel {
  final String tokenType;
  final String accessToken;
  final String refreshToken;

  const SwileModel({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory SwileModel.fromJson(Map<String, dynamic> json) {
    return SwileModel(
      tokenType: json['token_type'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() => {
    "token_type": tokenType.toString(),
    "access_token": accessToken.toString(),
    "refresh_token": refreshToken.toString(),
  };

  @override
  String toString() => "${toJson()}";
}
