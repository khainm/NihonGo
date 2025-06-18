import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthFooter extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback? onActionTap;

  const AuthFooter({
    Key? key,
    required this.questionText,
    required this.actionText,
    this.onActionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(questionText),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionText,
            style: AppTheme.linkTextStyle,
          ),
        ),
      ],
    );
  }
}
