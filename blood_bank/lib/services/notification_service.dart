import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> msgKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbarError(String msg) {
    final snackbar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      backgroundColor: Colors.red.withOpacity(0.9),
    );
    msgKey.currentState!.showSnackBar(snackbar);
  }
}
