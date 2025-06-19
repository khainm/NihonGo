import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoadingIndicator({
    Key? key,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: color ?? AppTheme.primaryColor,
        ),
        if (message != null) ...[
          AppTheme.verticalSpaceMedium,
          Text(
            message!,
            style: AppTheme.subtitleTextStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  const AppLoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AppLoadingIndicator(message: loadingMessage),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
