import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/add_expense_controller.dart';
import 'package:get/get.dart';

class ExpenseParticipantsSection extends StatelessWidget {
  final Trip trip;
  final AddExpenseController controller;

  const ExpenseParticipantsSection({
    super.key,
    required this.trip,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final participants = trip.participants;

    return Obx(
      () {
        final allSelected =
            controller.selectedParticipants.length == participants.length;

        return Column(
          children: [
            const SizedBox(height: 20),

            // الهيدر: Split between و Select all / Deselect all
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Split between',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryText,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.toggleSelectAll(
                      participants
                          .map((participant) => participant.id)
                          .toList(),
                    );
                  },
                  child: Text(
                    allSelected ? 'Deselect all' : 'Select all',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // قائمة المشاركين بدون أي أنيميشن وبدون تأثير الضغط السكني
            ...participants.map(
              (participant) {
                final selected =
                    controller.selectedParticipants.contains(participant.id);

                return InkWell(
                  onTap: () {
                    controller.toggleParticipant(participant.id);
                  },
                  // إلغاء التأثير السكني (الرمادي) عند الضغط تماماً هنا 👇
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const SizedBox(width: 18),

                        // مساحة ثابتة للأيقونة لمنع اهتزاز أو تحرك النص
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 24,
                                  color: AppColors.green,
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          child: Text(
                            participant.name,
                            style: const TextStyle(
                              fontSize: 17,
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
