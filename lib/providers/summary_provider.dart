import 'package:flutter/foundation.dart';

import '../models/question_model.dart';
import '../models/summary_model.dart';
import '../services/api_service.dart';
import '../services/camera_service.dart';

class SummaryProvider extends ChangeNotifier {
  static const String _emptyInputMessage = 'אנא הזינו טקסט לפני העיבוד.';

  SummaryProvider({ApiService? apiService, CameraService? cameraService})
      : _apiService = apiService ?? const ApiService(),
        _cameraService = cameraService ?? const CameraService();

  final ApiService _apiService;
  final CameraService _cameraService;

  SummaryModel? _summary;
  bool _isLoading = false;
  String? _errorMessage;

  SummaryModel? get summary => _summary;
  bool get hasSummary => _summary != null;
  List<QuestionModel> get questions => _summary?.questions ?? const <QuestionModel>[];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> processMaterial(String input) async {
    if (input.trim().isEmpty) {
      _errorMessage = _emptyInputMessage;
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final result = await _apiService.generateSummaryAndQuestions(input);
      _summary = result;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (error, stackTrace) {
      _summary = null;
      _errorMessage = error.toString();
      if (kDebugMode) {
        print('Failed to process material: $error');
        print(stackTrace);
      }
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> processCameraFlow() async {
    _setLoading(true);
    try {
      final extractedText = await _cameraService.captureAndExtractText();
      return await processMaterial(extractedText);
    } catch (error, stackTrace) {
      _summary = null;
      _errorMessage = error.toString();
      if (kDebugMode) {
        print('Camera flow failed: $error');
        print(stackTrace);
      }
      notifyListeners();
      _setLoading(false);
      return false;
    }
  }

  void reset() {
    _summary = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }
}
