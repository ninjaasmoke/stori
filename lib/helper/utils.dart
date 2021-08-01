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
