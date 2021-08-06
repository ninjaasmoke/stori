import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:stori/constants.dart';

onCopyData({required String copyLink}) async {
  ClipboardData data = ClipboardData(text: copyLink);
  await Clipboard.setData(data);
  Fluttertoast.showToast(
    msg: "Copied link",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: primaryTextColor,
    textColor: darkTextColor,
    fontSize: 14.0,
  );
}

onShareData(BuildContext context, String text, String subject) async {
  await Share.share(
    text,
    subject: subject,
    sharePositionOrigin: Rect.largest,
  );
}

double dp(double val, int places) {
  num mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

double distance(GeoPoint loc1, GeoPoint loc2) {
  var p = 0.017453292519943295; // Math.PI / 180
  var c = cos;
  var a = 0.5 -
      c((loc2.latitude - loc1.latitude) * p) / 2 +
      c(loc1.latitude * p) *
          c(loc2.latitude * p) *
          (1 - c((loc2.longitude - loc1.longitude) * p)) /
          2;

  return dp(12742 * asin(sqrt(a)), 2); // 2 * R; R = 6371 km
}
