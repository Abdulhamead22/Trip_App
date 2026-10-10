import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/add_expense_controller.dart';
import 'package:flutter_application_1/features/expenses/presentation/widgets/expense_custom_split_section.dart';
import 'package:flutter_application_1/features/expenses/presentation/widgets/expense_participants_section.dart';
import 'package:flutter_application_1/features/expenses/presentation/widgets/expense_payment_section.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  final Trip trip;
  final Expense? expense;

  AddExpenseScreen({
    super.key,
    required this.trip,
    this.expense,
  });

  final AddExpenseController expenseController =
      Get.find<AddExpenseController>();

  Future<void> _addExpense() async {
    final payments = <String, double>{};

    for (final participant in trip.participants) {
      final value = double.tryParse(
        expenseController.paymentControllers[participant.id]!.text.trim(),
      );

      if (value != null && value > 0) {
        payments[participant.id] = value;
      }
    }

    final splitAmounts = <String, double>{};

    if (expenseController.isCustom.value) {
      for (final participant in trip.participants) {
        if (!expenseController.selectedParticipants.contains(participant.id)) {
          continue;
        }

        final value = double.tryParse(
          expenseController.splitAmountControllers[participant.id]!.text.trim(),
        );

        if (value != null) {
          splitAmounts[participant.id] = value;
        }
      }
    }

    final success = await expenseController.saveExpense(
      trip: trip,
      existingExpense: expense,
      title: expenseController.titleController.text,
      amountText: expenseController.amountController.text,
      payments: payments,
      splitAmounts: splitAmounts,
    );

    if (!success) {
      return;
    }

    Get.back();
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryText,
      ),
    );
  }

  Widget _buildSplitButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE1F5EF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? null
              : Border.all(
                  color: AppColors.border,
                  width: 1.3,
                ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.green : const Color(0xFF637590),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    expense == null ? 'Add Expense' : 'Edit Expense',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildLabel('Expense Name'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: expenseController.titleController,
                hintText: 'Dinner',
                fontSize: 18,
              ),
              const SizedBox(height: 14),
              _buildLabel('Amount'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: expenseController.amountController,
                hintText: '0',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                fontSize: 18,
              ),
              const SizedBox(height: 14),
              ExpensePaymentSection(
                trip: trip,
                paymentControllers: expenseController.paymentControllers,
              ),
              const SizedBox(height: 20),
              ExpenseParticipantsSection(
                trip: trip,
                controller: expenseController,
              ),
              const SizedBox(height: 14),
              _buildLabel('Split Type'),
              const SizedBox(height: 10),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _buildSplitButton(
                        title: 'Equal',
                        selected: !expenseController.isCustom.value,
                        onTap: () {
                          expenseController.changeSplitType(false);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildSplitButton(
                        title: 'Custom',
                        selected: expenseController.isCustom.value,
                        onTap: () {
                          expenseController.changeSplitType(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  if (!expenseController.isCustom.value) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 14),
                      ExpenseCustomSplitSection(
                        trip: trip,
                        controller: expenseController,
                        splitAmountControllers:
                            expenseController.splitAmountControllers,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Obx(() {
                final loading = expenseController.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : _addExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.green.withOpacity(0.6),
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      loading
                          ? (expense == null ? 'Adding...' : 'Updating...')
                          : (expense == null
                              ? 'Add Expense'
                              : 'Update Expense'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
