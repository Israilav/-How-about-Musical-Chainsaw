import 'package:flutter/material.dart';

import 'providers/summary_provider.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/scan_screen.dart';
import 'utils/constants.dart';

void main() {
  final summaryProvider = SummaryProvider.initialize();

  runApp(
    SummaryProviderScope(
      notifier: summaryProvider,
      child: const DocumentSummaryApp(),
    ),
  );
}

class DocumentSummaryApp extends StatelessWidget {
  const DocumentSummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      routes: {
        homeRoute: (_) => const HomeScreen(),
        scanRoute: (_) => const ScanScreen(),
        resultsRoute: (_) => const ResultsScreen(),
      },
    );
  }
}
