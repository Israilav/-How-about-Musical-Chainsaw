import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/summary_model.dart';
import '../providers/summary_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = RoutePaths.home;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Copy.homeSubtitle,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: Copy.scanButton,
                icon: Icons.camera_alt_outlined,
                onPressed: () {
                  Navigator.pushNamed(context, RoutePaths.scan);
                },
              ),
              const SizedBox(height: 32),
              Text(
                Copy.summaryHeader,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Consumer<SummaryProvider>(
                  builder: (BuildContext context, SummaryProvider provider, _) {
                    if (provider.isLoading) {
                      return const LoadingIndicator(message: 'Fetching summary...');
                    }

                    if (provider.error != null) {
                      return _SummaryError(
                        message: provider.error!,
                        onRetry: () {
                          provider.reset();
                          Navigator.pushNamed(context, RoutePaths.scan);
                        },
                      );
                    }

                    final summary = provider.summary;
                    if (summary == null) {
                      return const _EmptySummary();
                    }

                    return _SummaryDetails(summary: summary);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryDetails extends StatelessWidget {
  const _SummaryDetails({required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<SummaryProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              summary.title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              truncate(summary.description, maxLength: 180),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Generated: ${formatShortDate(summary.createdAt)}',
              style: theme.textTheme.bodySmall,
            ),
            const Spacer(),
            CustomButton(
              label: 'View Full Summary',
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.results);
              },
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'Refresh Questions',
              isPrimary: false,
              icon: Icons.refresh,
              onPressed: () => provider.refreshQuestions(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: Copy.retry,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.description_outlined,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              Copy.emptyState,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
