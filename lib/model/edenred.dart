class EdenredModel {
  final String idToken;
  final String accessToken;
  final String refreshToken;

  const EdenredModel({
    required this.idToken,
    required this.accessToken,
    required this.refreshToken,
  });

  factory EdenredModel.fromJson(Map<String, dynamic> json) {
    return EdenredModel(
      idToken: json['id_token'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id_token": idToken.toString(),
        "access_token": accessToken.toString(),
        "refresh_token": refreshToken.toString(),
      };

  @override
  String toString() => "${toJson()}";
}
