import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon = Icons.category_outlined,
    this.hintText,
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final String? hintText;
  final FormFieldValidator<String?>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
          iconEnabledColor: AppColors.outline,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.outline),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
        ),
      ],
    );
  }
}
