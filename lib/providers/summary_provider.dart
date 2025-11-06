import 'package:flutter/foundation.dart';

import '../models/summary_model.dart';
import '../services/api_service.dart';

class SummaryProvider extends ChangeNotifier {
  SummaryProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Summary? _summary;
  bool _isLoading = false;
  String? _error;

  Summary? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSummary(String imagePath) async {
    _setLoading(true);
    _error = null;
    try {
      final fetchedSummary = await _apiService.fetchSummary(imagePath: imagePath);
      _summary = fetchedSummary;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      debugPrint('Failed to fetch summary: $error\n$stackTrace');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshQuestions() async {
    final currentSummary = _summary;
    if (currentSummary == null) return;

    try {
      final questions = await _apiService
          .fetchSuggestedQuestions(summaryId: currentSummary.id);
      _summary = currentSummary.copyWith(questions: questions);
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      debugPrint('Failed to refresh questions: $error\n$stackTrace');
      notifyListeners();
    }
  }

  void reset() {
    _summary = null;
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }
}
