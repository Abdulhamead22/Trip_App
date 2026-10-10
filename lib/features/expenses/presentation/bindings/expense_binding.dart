import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/add_expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/calculate_settlement.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/delete_expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/update_expense.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/add_expense_controller.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:get/get.dart';

class ExpenseBinding extends Bindings {
  final Trip trip;
  final Expense? expense;

  ExpenseBinding({
    required this.trip,
    this.expense,
  });

  @override
  void dependencies() {
    final controller = AddExpenseController(
      addExpenseUseCase: Get.find<AddExpenseUseCase>(),
      updateExpenseUseCase: Get.find<UpdateExpenseUseCase>(),
    );

    controller.initialize(
      trip: trip,
      expense: expense,
    );

    Get.put<AddExpenseController>(controller);
    Get.put<ExpenseController>(
  ExpenseController(
    deleteExpenseUseCase: Get.find<DeleteExpenseUseCase>(),
    calculateSettlementUseCase:
        Get.find<CalculateSettlementUseCase>(),
  ),
  permanent: true,
);
  }

  
}