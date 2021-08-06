import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? displayName;
  final String? username;
  final String? uid;
  final String? photoURL;
  final String? email;
  final List<String> hasBooks;
  final List<String> wantBooks;
  final GeoPoint location;
  final String createdDateTime;

  AppUser({
    required this.displayName,
    required this.username,
    required this.uid,
    required this.photoURL,
    required this.email,
    required this.hasBooks,
    required this.wantBooks,
    required this.location,
    required this.createdDateTime,
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      displayName: json["displayName"],
      username: json["username"],
      uid: json["uid"],
      photoURL: json["photoURL"],
      email: json["email"],
      hasBooks:
          json["hasBooks"] == null ? [] : json["hasBooks"].cast<String>() ?? [],
      wantBooks: json["wantBooks"] == null
          ? []
          : json["wantBooks"].cast<String>() ?? [],
      location: json["location"] ?? GeoPoint(0.0, 0.0),
      createdDateTime:
          json["createdDateTime"] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'uid': uid,
        'username': username,
        'photoURL': photoURL,
        'hasBooks': hasBooks,
        'wantBooks': wantBooks,
        'email': email,
        'location': location,
        'createdDateTime': createdDateTime,
      };
}
