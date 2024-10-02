import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ));
  }
}
