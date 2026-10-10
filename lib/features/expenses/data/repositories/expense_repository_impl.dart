import 'package:flutter_application_1/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:flutter_application_1/features/expenses/data/models/expense_model.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> addExpense(
    String tripId,
    Expense expense,
  ) async {
    final model = ExpenseModel.fromEntity(expense);

    await remoteDataSource.addExpense(
      tripId,
      model,
    );
  }

  @override
  Future<void> updateExpense(
    String tripId,
    Expense expense,
  ) async {
    final model = ExpenseModel.fromEntity(expense);

    await remoteDataSource.updateExpense(
      tripId,
      model,
    );
  }

  @override
  Future<void> deleteExpense(
    String tripId,
    String expenseId,
  ) async {
    await remoteDataSource.deleteExpense(
      tripId,
      expenseId,
    );
  }
}
