import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question_model.dart';
import '../models/summary_model.dart';
import '../providers/summary_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  static const String routeName = RoutePaths.results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Results'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Consumer<SummaryProvider>(
            builder: (BuildContext context, SummaryProvider provider, _) {
              if (provider.isLoading) {
                return const LoadingIndicator(message: 'Preparing results...');
              }

              final Summary? maybeSummary = provider.summary;
              if (maybeSummary == null) {
                return const _EmptyResults();
              }

              final Summary summary = maybeSummary;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    summary.title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generated on ${formatShortDate(summary.createdAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(
                                AppConstants.defaultPadding),
                            child: Text(
                              summary.description,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Suggested Questions',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (summary.hasQuestions)
                          ...summary.questions.map(
                            (Question question) => Card(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    AppConstants.defaultPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      question.text,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 12),
                                    if (question.options.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: question.options
                                            .map(
                                              (option) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    const Text('• '),
                                                    Expanded(
                                                      child: Text(option),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    if (question.answer != null) ...<Widget>[
                                      const SizedBox(height: 12),
                                      Text(
                                        'Answer: ${question.answer}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Text(
                            'No questions generated for this summary.',
                            style: theme.textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'Scan Another Document',
                    icon: Icons.camera_enhance_outlined,
                    onPressed: () {
                      provider.reset();
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.scan,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.find_in_page_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Capture a document to view its summary results here.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
