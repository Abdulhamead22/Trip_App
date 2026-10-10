import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/expenses/domain/repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase({
    required this.repository,
  });

  Future<void> call(
    String tripId,
    Expense expense,
  ) async {
    await repository.updateExpense(
      tripId,
      expense,
    );
  }
}