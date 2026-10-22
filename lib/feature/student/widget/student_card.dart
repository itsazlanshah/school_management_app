import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/feature/student/domain/student.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  });

  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainer),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.person,
            label: "Father's Name:",
            value: student.fatherName,
          ),
          _buildDetailRow(
            icon: Icons.school,
            label: 'Department:',
            value: student.department,
          ),
          _buildDetailRow(
            icon: Icons.badge,
            label: 'CNIC:',
            value: student.cnic,
          ),
          _buildDetailRow(
            icon: Icons.call,
            label: 'Phone:',
            value: student.phone,
          ),
          _buildDetailRow(
            icon: Icons.location_on,
            label: 'Address:',
            value: student.address,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Text(
            _getInitials(student.name),
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            student.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        PopupMenuButton<String>(
          tooltip: 'Student options',
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert, color: AppColors.outline),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.outline),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    if (words.isEmpty) return '';

    return words.take(2).map((word) => word[0].toUpperCase()).join();
  }
}
