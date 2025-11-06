import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/summary_provider.dart';
import '../services/camera_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  static const String routeName = RoutePaths.scan;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final CameraService _cameraService = CameraService();
  bool _isCapturing = false;
  String? _lastCapturePath;

  Future<void> _handleScan() async {
    setState(() => _isCapturing = true);

    try {
      final imagePath = await _cameraService.captureImage();
      if (!mounted) return;

      if (imagePath == null) {
        showSnackBar(context, 'Capture cancelled. Please try again.');
        return;
      }

      _lastCapturePath = imagePath;
      final summaryProvider = context.read<SummaryProvider>();
      await summaryProvider.fetchSummary(imagePath);

      if (!mounted) return;

      if (summaryProvider.error != null) {
        showSnackBar(context, summaryProvider.error!);
        return;
      }

      Navigator.pushNamed(context, RoutePaths.results);
    } catch (error) {
      if (!mounted) return;
      showSnackBar(context, 'Failed to capture image: $error');
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryProvider = context.watch<SummaryProvider>();
    final theme = Theme.of(context);
    final isBusy = _isCapturing || summaryProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Position your document within the camera frame.\n'
                'Once captured, we will generate a summary for you.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: isBusy
                      ? const LoadingIndicator(message: 'Processing image...')
                      : Icon(
                          Icons.camera_alt_outlined,
                          size: 72,
                          color: theme.colorScheme.primary,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              if (_lastCapturePath != null) ...<Widget>[
                Text(
                  'Last capture: $_lastCapturePath',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
              ],
              CustomButton(
                label: isBusy ? 'Processing...' : 'Capture & Summarize',
                icon: Icons.document_scanner_outlined,
                isLoading: isBusy,
                onPressed: isBusy ? null : _handleScan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
