import 'package:flutter/material.dart';
import 'package:stori/constants.dart';

showOverlay({
  required BuildContext context,
  required List<Widget> widgets,
  required bool barrierDismiss,
}) {
  showGeneralDialog(
    barrierDismissible: barrierDismiss,
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            backgroundColor: scaffoldBGColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [widget],
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets,
      );
    },
  );
}
