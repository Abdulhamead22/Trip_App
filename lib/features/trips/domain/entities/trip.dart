import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';

class Trip {
  final String id;
  final String name;
  final String currency;
  final String ownerId;
  final DateTime createdAt;
  final List<Participant> participants;
  final List<Expense> expenses;

  const Trip({
    required this.id,
    required this.name,
    required this.currency,
    required this.ownerId,
    required this.createdAt,
    required this.participants,
    required this.expenses,
  });

  double get total {
    return expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }
}
