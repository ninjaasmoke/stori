class AppUser {
  final String? displayName;
  final String? username;
  final String? uid;

  AppUser({
    required this.displayName,
    required this.username,
    required this.uid,
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      displayName: json["displayName"],
      username: json["username"],
      uid: json["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'uid': uid,
        'username': username,
      };
}
