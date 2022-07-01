import 'package:flutter/material.dart';

class Message {
  static void showSuccess(
      {required BuildContext context,
      required String message,
      VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("成功!"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("好的"),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showError(
      {required BuildContext context,
      required String message,
      VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("错误!"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("好的"),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("错误!"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("好的"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
