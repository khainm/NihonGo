import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType type;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.type = ButtonType.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        style: _getButtonStyle(),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: AppTheme.buttonTextStyle,
              ),
      ),
    );
  }

  ButtonStyle _getButtonStyle() {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.getPrimaryButtonStyle(enabled: onPressed != null);
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.primaryColor,
          side: const BorderSide(color: AppTheme.primaryColor),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
    }
  }
}

enum ButtonType { primary, secondary }
