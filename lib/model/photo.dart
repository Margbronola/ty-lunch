class PhotoModel {
  final int id;
  final String location;

  const PhotoModel({required this.id, required this.location});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id" : id,
    "location" : location
  };

  @override
  String toString() => "${toJson()}";
}
