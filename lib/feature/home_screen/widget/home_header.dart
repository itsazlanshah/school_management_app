import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/feature/authentication/presentation/pages/sign_in.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.school, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 8),
          Text('Home', style: AppTextStyles.headlineSmall),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'User menu',
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.onPrimary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
