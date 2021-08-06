import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stori/models/UserModel.dart';

class FireStoreService {
  FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  Future<AppUser> getUser(String? uid) async {
    AppUser _user;
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestoreInstance.collection("users").doc(uid).get();
      _user = AppUser.fromJson(doc.data() ?? {});
    } catch (e) {
      throw Exception(e);
    }
    return _user;
  }

  Future addUser(AppUser user) async {
    Map<String, dynamic> userObject = user.toJson();
    await _firestoreInstance
        .collection("users")
        .doc(user.uid)
        .set(userObject)
        .whenComplete(() {
      return user;
    }).catchError((e) {
      throw Exception(e);
    });
  }

  Future updateUser(AppUser user) async {
    /// this overrites the entire user object
    /// find a way to update only the changed fields

    Map<String, dynamic> userObject = user.toJson();
    await _firestoreInstance
        .collection("users")
        .doc(user.uid)
        .update(userObject)
        .whenComplete(() {
      return user;
    }).catchError((e) {
      throw Error();
    });
  }

  Future addBook(String uid, String booksType, String book) async {
    await _firestoreInstance.collection("users").doc(uid).update({
      booksType: FieldValue.arrayUnion([book])
    }).whenComplete(() {
      return;
    }).catchError((e) {
      throw Exception(e);
    });
  }

  Future removeBook(String uid, String booksType, String book) async {
    await _firestoreInstance.collection("users").doc(uid).update({
      booksType: FieldValue.arrayRemove([book])
    }).whenComplete(() {
      return;
    }).catchError((e) {
      throw Exception(e);
    });
  }

  Future<List<String>> getTopics() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> res =
          await _firestoreInstance.collection("books").doc("topics").get();
      List<String> _books = res.data()!.keys.toList();
      return _books;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> getBookOfDay() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> res = await _firestoreInstance
          .collection("books")
          .doc("bookOfTheDay")
          .get();
      return res.data()!["title"];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future editBookOfDay(String book) async {
    await _firestoreInstance
        .collection("books")
        .doc("bookOfTheDay")
        .set({'title': book}).whenComplete(() {
      return;
    }).catchError((e) {
      throw Exception(e);
    });
  }

  Future<List<AppUser>> getClosestUsers(GeoPoint location) async {
    double distance = 1.0;

    double lat = 0.009;
    double lon = 0.0001;

    double lowerLat = location.latitude - (lat * distance);
    double lowerLon = location.longitude - (lon * distance);

    double greaterLat = location.latitude + (lat * distance);
    double greaterLon = location.longitude + (lon * distance);

    GeoPoint lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    GeoPoint greaterGeopoint = GeoPoint(greaterLat, greaterLon);

    List<AppUser> _users = [];

    try {
      Query<Map<String, dynamic>> query = _firestoreInstance
          .collection('users')
          .where('location', isGreaterThan: lesserGeopoint)
          .where('location', isLessThan: greaterGeopoint);
      QuerySnapshot<Map<String, dynamic>> data = await query.get();
      for (var user in data.docs.toList()) {
        _users.add(AppUser.fromJson(user.data()));
      }
      return _users;
    } catch (e) {
      throw Exception(e);
    }
  }
}
