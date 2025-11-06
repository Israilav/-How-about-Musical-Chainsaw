import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _goToUpload(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.scan, arguments: const ScanArguments(isCamera: false));
  }

  void _goToCamera(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.scan, arguments: const ScanArguments(isCamera: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.welcomeHeadline,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.welcomeDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton(
              icon: Icons.upload_file,
              label: AppStrings.uploadMaterial,
              onPressed: () => _goToUpload(context),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomButton(
              icon: Icons.photo_camera,
              label: AppStrings.scanWithCamera,
              onPressed: () => _goToCamera(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanArguments {
  const ScanArguments({required this.isCamera});

  final bool isCamera;
}
