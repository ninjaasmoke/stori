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
    QuerySnapshot<Map<String, dynamic>> res =
        await _firestoreInstance.collection("topics").get();
    return res.docs.map((d) => d.id).toList();
  }

  Future<String> getBookOfDay() async {
    DocumentSnapshot<Map<String, dynamic>> res =
        await _firestoreInstance.collection("bookOfDay").doc("bookOfDay").get();
    return res.data()!["title"];
  }
}
