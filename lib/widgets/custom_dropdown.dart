import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;

  const CustomDropdown(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.mutedText,
      ),
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.darkText,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.green,
            width: 1.5,
          ),
        ),
      ),
      items: items,
    );
  }
}
