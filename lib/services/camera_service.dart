class CameraService {
  const CameraService();

  Future<String> captureAndExtractText() async {
    await Future.delayed(const Duration(seconds: 1));

    return 'זהו טקסט דוגמה שהתקבל מסריקת מסמך באמצעות מצלמה.';
  }
}
