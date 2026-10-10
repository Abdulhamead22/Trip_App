import 'package:flutter_application_1/features/expenses/domain/entities/settlement.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/calculate_settlement.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/delete_expense.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final CalculateSettlementUseCase calculateSettlementUseCase;

  ExpenseController({
    required this.deleteExpenseUseCase,
    required this.calculateSettlementUseCase,
  });

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<bool> deleteExpense(
    String tripId,
    String expenseId,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await deleteExpenseUseCase(
        tripId,
        expenseId,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete expense';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  List<Settlement> calculateSettlement(Trip trip) {
    return calculateSettlementUseCase(trip);
  }
}