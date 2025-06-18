import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? iconAsset;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.iconAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTheme.verticalSpaceExtraLarge,
        // Icon/Logo
        SizedBox(
          height: 56,
          width: 56,
          child: iconAsset != null
              ? Image.asset(
                  iconAsset!,
                  height: 56,
                  width: 56,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.local_florist,
                    color: Colors.pink,
                    size: 56,
                  ),
                )
              : const Icon(
                  Icons.local_florist,
                  color: Colors.pink,
                  size: 56,
                ),
        ),
        AppTheme.verticalSpaceMedium,
        Text(
          title,
          style: AppTheme.titleTextStyle,
          textAlign: TextAlign.center,
        ),
        AppTheme.verticalSpaceSmall,
        Text(
          subtitle,
          style: AppTheme.subtitleTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
