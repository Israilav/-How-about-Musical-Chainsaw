import 'package:flutter/material.dart';

class AppStrings {
  static const String appName = 'סיכומון';
  static const String homeTitle = 'סיכומון';
  static const String welcomeHeadline = 'היי, מוכנים ללמוד חכם יותר?';
  static const String welcomeDescription =
      'העלו חומר לימודי או סרקו אותו מהמכשיר, ואנו נהפוך אותו לסיכום ממוקד ולשאלות תרגול.';
  static const String uploadMaterial = 'העלאת חומר';
  static const String scanWithCamera = 'סריקה במצלמה';
  static const String scanTitle = 'הכנת החומר';
  static const String enterTextLabel = 'הדביקו כאן את הטקסט שלכם';
  static const String processMaterial = 'עיבוד החומר';
  static const String processing = 'מעבד את החומר...';
  static const String resultsTitle = 'התוצאות שלי';
  static const String mySummary = 'הסיכום שלי';
  static const String letsPractice = 'בוא נתרגל';
  static const String tryAgain = 'ניסיון נוסף';
  static const String answer = 'בחרו תשובה';
  static const String correctAnswer = 'תשובה נכונה!';
  static const String incorrectAnswer = 'נסו שוב.';
  static const String emptyInputError = 'אנא הזינו טקסט לפני העיבוד.';
  static const String genericError = 'משהו השתבש. נסו שוב מאוחר יותר.';
}

class AppRoutes {
  static const String home = '/';
  static const String scan = '/scan';
  static const String results = '/results';
}

class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppDurations {
  static const Duration medium = Duration(milliseconds: 400);
}

class AppColors {
  static const Color primary = Color(0xFF5C6BC0);
  static const Color accent = Color(0xFF26A69A);
  static const Color background = Color(0xFFF6F7FB);
}
