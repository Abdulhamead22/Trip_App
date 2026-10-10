import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(
    String tripId,
    Expense expense,
  );

  Future<void> updateExpense(
    String tripId,
    Expense expense,
  );

  Future<void> deleteExpense(
    String tripId,
    String expenseId,
  );
}
