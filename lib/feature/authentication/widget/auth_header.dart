import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.subtitle = 'School Management System'});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'EduManager',
              style: AppTextStyles.headline,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}
