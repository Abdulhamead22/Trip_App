import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/add_expense_controller.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';

class ExpenseCustomSplitSection extends StatelessWidget {
  final Trip trip;
  final AddExpenseController controller;
  final Map<String, TextEditingController> splitAmountControllers;

  const ExpenseCustomSplitSection({
    super.key,
    required this.trip,
    required this.controller,
    required this.splitAmountControllers,
  });

  @override
  Widget build(BuildContext context) {
    final participants = trip.participants.where(
      (participant) => controller.selectedParticipants.contains(participant.id),
    );

    return Column(
      children: participants.map((participant) {
        final splitController = splitAmountControllers[participant.id]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  participant.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              SizedBox(
                width: 95,
                child: CustomTextField(
                  controller: splitController,
                  hintText: '0',
                  suffixText: trip.currency,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  textAlign: TextAlign.center,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fillColor: AppColors.fillTextField,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
