import 'package:flutter/material.dart';

IconData getCategoryIcon(String title) {
  final value = title.toLowerCase();

  if (value.contains('hotel') ||
      value.contains('room') ||
      value.contains('resort')) {
    return Icons.hotel_outlined;
  }

  if (value.contains('food') ||
      value.contains('dinner') ||
      value.contains('lunch') ||
      value.contains('restaurant')) {
    return Icons.restaurant_outlined;
  }

  if (value.contains('transport') ||
      value.contains('taxi') ||
      value.contains('car') ||
      value.contains('bus')) {
    return Icons.directions_car_outlined;
  }

  if (value.contains('ticket') || value.contains('tickets')) {
    return Icons.confirmation_number_outlined;
  }

  return Icons.receipt_long_outlined;
}
