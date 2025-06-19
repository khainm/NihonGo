import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(AppConstants.primaryColorValue);
  static const Color backgroundColor = Color(AppConstants.backgroundColorValue);
  static const Color inputBackgroundColor = Color(AppConstants.inputBackgroundValue);
  static const Color errorColor = Colors.red;
  static const Color successColor = Colors.green;
  static const Color textColor = Colors.black87;
  static const Color hintTextColor = Colors.grey;
  
  // Text Styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
  
  static const TextStyle subtitleTextStyle = TextStyle(
    fontSize: 16,
    color: hintTextColor,
  );
  
  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle linkTextStyle = TextStyle(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  );
  
  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      filled: true,
      fillColor: inputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
    );
  }
  
  // Button Styles
  static ButtonStyle getPrimaryButtonStyle({bool enabled = true}) {
    return ElevatedButton.styleFrom(
      backgroundColor: enabled ? primaryColor : Colors.grey,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    );
  }
  
  // Container Decorations
  static BoxDecoration getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  // Spacing
  static const SizedBox verticalSpaceSmall = SizedBox(height: 8);
  static const SizedBox verticalSpaceMedium = SizedBox(height: 16);
  static const SizedBox verticalSpaceLarge = SizedBox(height: 24);
  static const SizedBox verticalSpaceExtraLarge = SizedBox(height: 32);
  
  static const SizedBox horizontalSpaceSmall = SizedBox(width: 8);
  static const SizedBox horizontalSpaceMedium = SizedBox(width: 16);
  static const SizedBox horizontalSpaceLarge = SizedBox(width: 24);
}
