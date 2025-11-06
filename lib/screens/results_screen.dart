import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/question_model.dart';
import '../providers/summary_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final Map<String, int> _selectedAnswers = <String, int>{};

  void _selectAnswer(QuestionModel question, int index) {
    setState(() {
      _selectedAnswers[question.id] = index;
    });
    final isCorrect = question.correctAnswerIndex == index;
    final message = isCorrect ? AppStrings.correctAnswer : AppStrings.incorrectAnswer;
    showSnackBarMessage(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.resultsTitle),
      ),
      body: Consumer<SummaryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          final summary = provider.summary;
          if (summary == null) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'לא נמצא סיכום להצגה. חזרו למסך הבית כדי להתחיל מחדש.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomButton(
                    icon: Icons.home,
                    label: AppStrings.homeTitle,
                    onPressed: () => Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home)),
                  ),
                ],
              ),
            );
          }

          final questions = summary.questions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.mySummary,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  elevation: 0,
                  color: AppColors.background,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      summary.summary,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  AppStrings.letsPractice,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final selected = _selectedAnswers[question.id];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question.questionText,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ...List<Widget>.generate(question.options.length, (optionIndex) {
                              final option = question.options[optionIndex];
                              return RadioListTile<int>(
                                value: optionIndex,
                                groupValue: selected,
                                onChanged: (_) => _selectAnswer(question, optionIndex),
                                title: Text(option),
                                activeColor: AppColors.accent,
                              );
                            }),
                            if (selected != null)
                              Padding(
                                padding: const EdgeInsets.only(top: AppSpacing.sm),
                                child: Text(
                                  selected == question.correctAnswerIndex
                                      ? AppStrings.correctAnswer
                                      : '${AppStrings.incorrectAnswer} התשובה הנכונה היא אפשרות ${question.correctAnswerIndex + 1}.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: selected == question.correctAnswerIndex
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemCount: questions.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
