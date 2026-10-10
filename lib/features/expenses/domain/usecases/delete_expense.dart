import 'package:flutter_application_1/features/expenses/domain/repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase({
    required this.repository,
  });

  Future<void> call(
    String tripId,
    String expenseId,
  ) async {
    await repository.deleteExpense(
      tripId,
      expenseId,
    );
  }
}