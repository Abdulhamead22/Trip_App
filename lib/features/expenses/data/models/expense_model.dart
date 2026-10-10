import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.payments,
    required super.splitWith,
    required super.splitAmounts,
    required super.createdAt,
  });
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      payments: expense.payments,
      splitWith: expense.splitWith,
      splitAmounts: expense.splitAmounts,
      createdAt: expense.createdAt,
    );
  }

  factory ExpenseModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final timestamp = map['createdAt'] as Timestamp?;

    final paymentsMap = Map<String, dynamic>.from(
      map['payments'] ?? {},
    );
    final splitAmountsMap = Map<String, dynamic>.from(
      map['splitAmounts'] ?? {},
    );

    return ExpenseModel(
      id: id,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      payments: paymentsMap.map(
        (key, value) => MapEntry(
          key,
          (value as num).toDouble(),
        ),
      ),
      splitWith: List<String>.from(
        map['splitWith'] ?? [],
      ),
      splitAmounts: splitAmountsMap.map(
        (key, value) => MapEntry(
          key,
          (value as num).toDouble(),
        ),
      ),
      createdAt: timestamp?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'payments': payments,
      'splitWith': splitWith,
      'splitAmounts': splitAmounts,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
