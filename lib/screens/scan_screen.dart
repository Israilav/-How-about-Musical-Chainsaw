import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/summary_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';
import 'home_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final TextEditingController _controller;
  bool _useCameraFlow = false;
  bool _hasLoadedArgs = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedArgs) {
      return;
    }
    final args = ModalRoute.of(context)?.settings.arguments as ScanArguments?;
    _useCameraFlow = args?.isCamera ?? false;
    _hasLoadedArgs = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processText() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      showSnackBarMessage(context, AppStrings.emptyInputError);
      return;
    }

    final provider = context.read<SummaryProvider>();
    final didSucceed = await provider.processMaterial(text);
    if (!mounted) {
      return;
    }
    if (didSucceed) {
      Navigator.pushNamed(context, AppRoutes.results);
    } else {
      showSnackBarMessage(context, provider.errorMessage ?? AppStrings.genericError);
    }
  }

  Future<void> _captureWithCamera() async {
    final provider = context.read<SummaryProvider>();
    final didSucceed = await provider.processCameraFlow();
    if (!mounted) {
      return;
    }
    if (didSucceed) {
      Navigator.pushNamed(context, AppRoutes.results);
    } else {
      showSnackBarMessage(context, provider.errorMessage ?? AppStrings.genericError);
    }
  }

  void _fillWithSample() {
    const sampleText =
        'מדינת ישראל קמה בשנת 1948 ומאז היא מרכז טכנולוגי וחינוכי מוביל. סיכומון מאפשר לכל לומד להפיק סיכום איכותי ושאלות תרגול מהחומר שלו.';
    _controller.text = sampleText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.scanTitle),
      ),
      body: Consumer<SummaryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: LoadingIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.enterTextLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: AppStrings.enterTextLabel,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.auto_fix_high),
                      tooltip: 'טקסט לדוגמה',
                      onPressed: _fillWithSample,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomButton(
                  icon: Icons.play_circle_fill,
                  label: AppStrings.processMaterial,
                  onPressed: _processText,
                ),
                const SizedBox(height: AppSpacing.md),
                if (_useCameraFlow)
                  CustomButton(
                    icon: Icons.photo_camera_back,
                    label: AppStrings.scanWithCamera,
                    onPressed: _captureWithCamera,
                  )
                else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text(AppStrings.uploadMaterial),
                    onPressed: () => showSnackBarMessage(
                      context,
                      'תמיכת העלאת קבצים תתווסף בהמשך.',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
