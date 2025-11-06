import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/summary_provider.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/scan_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SummaryApp());
}

class SummaryApp extends StatelessWidget {
  const SummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SummaryProvider>(
      create: (_) => SummaryProvider(),
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: HomeScreen.routeName,
        routes: <String, WidgetBuilder>{
          HomeScreen.routeName: (_) => const HomeScreen(),
          ScanScreen.routeName: (_) => const ScanScreen(),
          ResultsScreen.routeName: (_) => const ResultsScreen(),
        },
      ),
    );
  }
}
