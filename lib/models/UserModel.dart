class AppUser {
  final String? displayName;
  final String? username;
  final String? uid;
  final String? photoURL;

  AppUser({
    required this.displayName,
    required this.username,
    required this.uid,
    required this.photoURL,
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      displayName: json["displayName"],
      username: json["username"],
      uid: json["uid"],
      photoURL: json["photoURL"],
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'uid': uid,
        'username': username,
        'photoURL': photoURL,
      };
}
