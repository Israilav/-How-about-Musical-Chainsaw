import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/summary_provider.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/scan_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const SikumonApp());
}

class SikumonApp extends StatelessWidget {
  const SikumonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SummaryProvider(),
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.scan: (_) => const ScanScreen(),
          AppRoutes.results: (_) => const ResultsScreen(),
        },
      ),
    );
  }
}
