import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/expenses/data/models/expense_model.dart';

class ExpenseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpenseRemoteDataSource({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> _expensesCollection(
    String tripId,
  ) {
    return firestore
        .collection('trips')
        .doc(tripId)
        .collection('expenses');
  }

  Stream<List<ExpenseModel>> watchExpenses(String tripId) {
    return _expensesCollection(tripId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ExpenseModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> addExpense(
    String tripId,
    ExpenseModel expense,
  ) async {
    final expenseDoc = _expensesCollection(tripId).doc();

    await expenseDoc.set(
      expense.toMap(),
    );
  }

  Future<void> updateExpense(
    String tripId,
    ExpenseModel expense,
  ) async {
    await _expensesCollection(tripId)
        .doc(expense.id)
        .update(
          expense.toMap(),
        );
  }

  Future<void> deleteExpense(
    String tripId,
    String expenseId,
  ) async {
    await _expensesCollection(tripId)
        .doc(expenseId)
        .delete();
  }
}