  import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

Color getCategoryColor(String title) {
    final value = title.toLowerCase();

    if (value.contains('hotel') ||
        value.contains('room') ||
        value.contains('resort')) {
      return Colors.blue;
    }

    if (value.contains('food') ||
        value.contains('dinner') ||
        value.contains('lunch') ||
        value.contains('restaurant')) {
      return Colors.orange;
    }

    if (value.contains('transport') ||
        value.contains('taxi') ||
        value.contains('car') ||
        value.contains('bus')) {
      return Colors.purple;
    }

    if (value.contains('ticket') || value.contains('tickets')) {
      return Colors.teal;
    }

    return AppColors.green;
  }