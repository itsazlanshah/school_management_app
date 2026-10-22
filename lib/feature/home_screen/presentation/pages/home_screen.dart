import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/feature/home_screen/widget/action_card.dart';
import 'package:flutter_application_1/feature/home_screen/widget/home_header.dart';
import 'package:flutter_application_1/feature/student/presentation/pages/add_student.dart';
import 'package:flutter_application_1/feature/student/presentation/pages/show_student.dart';
import 'package:flutter_application_1/feature/teacher/presentation/pages/add_teacher.dart';
import 'package:flutter_application_1/feature/teacher/presentation/pages/show_teacher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(),
                    const SizedBox(height: 16),
                    _buildQuickActionsLabel(),
                    const SizedBox(height: 16),
                    _buildActionGrid(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back, Admin!', style: AppTextStyles.title),
        SizedBox(height: 4),
        Text(
          'Manage teachers and students records easily',
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildQuickActionsLabel() {
    return const Text(
      'QUICK ACTIONS',
      style: TextStyle(
        color: AppColors.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ActionCard(
          title: 'Add Teacher',
          subtitle: 'Register new teacher',
          icon: Icons.person_add,
          iconColor: AppColors.primary,
          iconBackgroundColor: AppColors.surfaceContainer,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AddTeacherScreen()),
            );
          },
        ),
        ActionCard(
          title: 'Add Student',
          subtitle: 'Enroll new student',
          icon: Icons.school,
          iconColor: AppColors.tertiaryContainer,
          iconBackgroundColor: AppColors.surfaceContainer,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AddStudentScreen()),
            );
          },
        ),
        ActionCard(
          title: 'Show Teachers',
          subtitle: 'View all teachers',
          icon: Icons.people,
          iconColor: AppColors.primaryContainer,
          iconBackgroundColor: AppColors.surfaceContainer,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ShowTeacherScreen(),
              ),
            );
          },
        ),
        ActionCard(
          title: 'Show Students',
          subtitle: 'View all students',
          icon: Icons.groups,
          iconColor: AppColors.secondary,
          iconBackgroundColor: AppColors.surfaceContainer,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ShowStudentScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
