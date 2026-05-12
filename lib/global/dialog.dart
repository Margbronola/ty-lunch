import 'package:flutter/material.dart';

class MyDialog {
  Future<void> scaleDialog(BuildContext context,
      {required Widget child}) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(.5),
      transitionBuilder: (_, a1, a2, chi) => Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: Center(child: child),
        ),
      ),
      pageBuilder: (_, a1, a2) => child,
    );
  }
}
