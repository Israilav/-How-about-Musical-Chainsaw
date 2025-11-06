import 'dart:math';

import '../utils/constants.dart';

class CameraService {
  final _random = Random();

  Future<String?> captureImage() async {
    await Future<void>.delayed(AppConstants.networkDelay);

    final success = _random.nextBool();
    if (!success) {
      return null;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '/tmp/camera_capture_$timestamp.jpg';
  }
}
