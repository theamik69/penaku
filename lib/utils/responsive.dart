import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static double getMaxWidth(BuildContext context) {
    if (isWeb(context)) return 1000;
    if (isTablet(context)) return 600;
    return double.infinity;
  }

  static int getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1800) {
      return 6;
    } else if (width >= 1200) {
      return 4;
    } else if (width >= 600) {
      return 2;
    } else {
      return 1;
    }
  }
}