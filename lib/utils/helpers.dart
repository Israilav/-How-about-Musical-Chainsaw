import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

String formatSummaryPreview(String summary) {
  const int maxLength = 160;
  if (summary.length <= maxLength) {
    return summary;
  }
  return '${summary.substring(0, maxLength)}...';
}
