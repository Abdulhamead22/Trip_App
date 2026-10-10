import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/add_expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/update_expense.dart';

class AddExpenseController extends GetxController {
  final AddExpenseUseCase addExpenseUseCase;
  final UpdateExpenseUseCase updateExpenseUseCase;

  AddExpenseController({
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
  });
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  final Map<String, TextEditingController> paymentControllers = {};

  final Map<String, TextEditingController> splitAmountControllers = {};
  final Set<String> selectedParticipants = <String>{}.obs;

  final RxBool isCustom = false.obs;
  final RxBool isLoading = false.obs;

  void toggleParticipant(String participantId) {
    if (selectedParticipants.contains(participantId)) {
      selectedParticipants.remove(participantId);
    } else {
      selectedParticipants.add(participantId);
    }
  }

  void initialize({
    required Trip trip,
    required Expense? expense,
  }) {
    titleController.clear();
    amountController.clear();

    paymentControllers.clear();
    splitAmountControllers.clear();

    selectedParticipants.clear();

    if (expense == null) {
      selectedParticipants.addAll(
        trip.participants.map(
          (participant) => participant.id,
        ),
      );

      isCustom.value = false;
    } else {
      titleController.text = expense.title;
      amountController.text = expense.amount.toString();

      selectedParticipants.addAll(
        expense.splitWith,
      );

      isCustom.value = expense.splitAmounts.isNotEmpty;
    }

    for (final participant in trip.participants) {
      paymentControllers[participant.id] = TextEditingController();

      splitAmountControllers[participant.id] = TextEditingController();

      if (expense != null) {
        final paidAmount = expense.payments[participant.id];

        if (paidAmount != null) {
          paymentControllers[participant.id]!.text = paidAmount.toString();
        }

        final splitAmount = expense.splitAmounts[participant.id];

        if (splitAmount != null) {
          splitAmountControllers[participant.id]!.text = splitAmount.toString();
        }
      }
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();

    for (final controller in paymentControllers.values) {
      controller.dispose();
    }

    for (final controller in splitAmountControllers.values) {
      controller.dispose();
    }

    super.onClose();
  }

  void toggleSelectAll(List<String> participantIds) {
    final allSelected = selectedParticipants.length == participantIds.length;

    if (allSelected) {
      selectedParticipants.clear();
    } else {
      selectedParticipants
        ..clear()
        ..addAll(participantIds);
    }
  }

  void changeSplitType(bool custom) {
    isCustom.value = custom;
  }

  Future<bool> saveExpense({
    required Trip trip,
    required Expense? existingExpense,
    required String title,
    required String amountText,
    required Map<String, double> payments,
    required Map<String, double> splitAmounts,
  }) async {
    final trimmedTitle = title.trim();

    final amount = double.tryParse(
      amountText.trim(),
    );

    if (trimmedTitle.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter expense name',
      );
      return false;
    }

    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Invalid amount',
        'Please enter a valid amount',
      );
      return false;
    }

    if (selectedParticipants.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please select at least one person',
      );
      return false;
    }

    if (payments.isEmpty) {
      Get.snackbar(
        'Missing information',
        'Please enter who paid and how much',
      );
      return false;
    }

    final totalPaid = payments.values.fold<double>(
      0,
      (sum, value) => sum + value,
    );

    if ((totalPaid - amount).abs() > 0.01) {
      Get.snackbar(
        'Invalid payments',
        'The total paid must equal the expense amount',
      );
      return false;
    }

    if (isCustom.value) {
      if (splitAmounts.length != selectedParticipants.length) {
        Get.snackbar(
          'Invalid split',
          'Please enter an amount for every selected person',
        );
        return false;
      }

      final hasInvalidAmount = splitAmounts.values.any(
        (value) => value <= 0,
      );

      if (hasInvalidAmount) {
        Get.snackbar(
          'Invalid split',
          'Split amounts cannot be negative',
        );
        return false;
      }

      final totalSplit = splitAmounts.values.fold<double>(
        0,
        (sum, value) => sum + value,
      );

      if ((totalSplit - amount).abs() > 0.01) {
        Get.snackbar(
          'Invalid split',
          'The total split must equal the expense amount',
        );
        return false;
      }
    }

    final expense = Expense(
      id: existingExpense?.id ?? '',
      title: trimmedTitle,
      amount: amount,
      payments: payments,
      splitWith: selectedParticipants.toList(),
      splitAmounts: isCustom.value ? splitAmounts : {},
      createdAt: existingExpense?.createdAt ?? DateTime.now(),
    );

    try {
      isLoading.value = true;

      if (existingExpense == null) {
        await addExpenseUseCase(
          trip.id,
          expense,
        );
      } else {
        await updateExpenseUseCase(
          trip.id,
          expense,
        );
      }

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save expense',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
