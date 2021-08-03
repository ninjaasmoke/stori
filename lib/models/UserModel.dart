class AppUser {
  final String? displayName;
  final String? username;
  final String? uid;
  final String? photoURL;
  final List<String> hasBooks;
  final List<String> wantBooks;

  AppUser({
    required this.displayName,
    required this.username,
    required this.uid,
    required this.photoURL,
    required this.hasBooks,
    required this.wantBooks,
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      displayName: json["displayName"],
      username: json["username"],
      uid: json["uid"],
      photoURL: json["photoURL"],
      hasBooks:
          json["hasBooks"] == null ? [] : json["hasBooks"].cast<String>() ?? [],
      wantBooks: json["wantBooks"] == null
          ? []
          : json["wantBooks"].cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'uid': uid,
        'username': username,
        'photoURL': photoURL,
        'hasBooks': hasBooks,
        'wantBooks': wantBooks,
      };
}
