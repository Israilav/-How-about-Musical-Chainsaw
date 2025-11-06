class AppConstants {
  AppConstants._();

  static const String appName = 'Scan & Summarize';
  static const String baseUrl = 'https://api.example.com/v1';
  static const Duration networkDelay = Duration(milliseconds: 750);
  static const double defaultPadding = 16.0;
}

class RoutePaths {
  RoutePaths._();

  static const String home = '/';
  static const String scan = '/scan';
  static const String results = '/results';
}

class Copy {
  Copy._();

  static const String homeSubtitle =
      'Capture a document to generate a quick, shareable summary.';
  static const String scanButton = 'Start Scan';
  static const String summaryHeader = 'Latest Summary';
  static const String emptyState =
      'No summary available yet. Scan a document to get started!';
  static const String retry = 'Retry';
}
