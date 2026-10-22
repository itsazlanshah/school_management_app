import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
  });

  final String label;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(color: AppColors.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.outline,
              fontSize: 14,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.outline),
            suffixIcon: suffixIcon,
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
        ),
      ],
    );
  }
}

class CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limitedDigits = digits.substring(
      0,
      digits.length > 13 ? 13 : digits.length,
    );
    final formatted = _formatCnic(limitedDigits);

    final digitsBeforeCursor = newValue.text
        .substring(0, newValue.selection.extentOffset)
        .replaceAll(RegExp(r'\D'), '')
        .length
        .clamp(0, limitedDigits.length);
    final separatorCount =
        (limitedDigits.length > 5 && digitsBeforeCursor >= 5 ? 1 : 0) +
        (limitedDigits.length > 12 && digitsBeforeCursor >= 12 ? 1 : 0);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: digitsBeforeCursor + separatorCount,
      ),
    );
  }

  String _formatCnic(String digits) {
    final firstPart = digits.substring(
      0,
      digits.length > 5 ? 5 : digits.length,
    );
    if (digits.length <= 5) return firstPart;

    final secondEnd = digits.length > 12 ? 12 : digits.length;
    final secondPart = digits.substring(5, secondEnd);
    final thirdPart = digits.length > 12 ? '-${digits.substring(12)}' : '';
    return '$firstPart-$secondPart$thirdPart';
  }
}
