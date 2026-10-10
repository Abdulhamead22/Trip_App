import 'package:flutter_application_1/features/expenses/domain/entities/settlement.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';

class CalculateSettlementUseCase {
  List<Settlement> call(Trip trip) {
    // حساب الرصيد النهائي لكل مشارك:
    // الرصيد الموجب = للشخص مال عند الآخرين.
    // الرصيد السالب = على الشخص مال للآخرين.
    final balances = _calculateBalances(trip);

    // استخراج الأشخاص الذين عليهم فلوس.
    final debtors = balances.entries
        .where((entry) => entry.value < -0.01)
        .map(
          (entry) => _Balance(
            participantId: entry.key,
            amount: -entry.value,
          ),
        )
        .toList();

    // استخراج الأشخاص الذين لهم فلوس.
    final creditors = balances.entries
        .where((entry) => entry.value > 0.01)
        .map(
          (entry) => _Balance(
            participantId: entry.key,
            amount: entry.value,
          ),
        )
        .toList();

    // إنشاء الدفعات المطلوبة في النهاية.
    return _createSettlements(
      debtors,
      creditors,
    );
  }

  Map<String, double> _calculateBalances(Trip trip) {
    // تخزين الرصيد النهائي لكل مشارك.
    final balances = <String, double>{
      for (final participant in trip.participants) participant.id: 0,
    };

    for (final expense in trip.expenses) {
      // حساب كم دفع كل شخص فعليًا في كل Expense.
      for (final payment in expense.payments.entries) {
        balances[payment.key] = (balances[payment.key] ?? 0) + payment.value;
      }

      // حساب كم المفروض كل شخص يتحمل من المصروف.
      if (expense.splitAmounts.isNotEmpty) {
        // إذا كانت هناك مبالغ محددة لكل شخص،
        // نستخدم المبلغ الخاص بكل مشارك.
        for (final split in expense.splitAmounts.entries) {
          balances[split.key] = (balances[split.key] ?? 0) - split.value;
        }
      } else if (expense.splitWith.isNotEmpty) {
        // إذا لم توجد مبالغ محددة،
        // يتم تقسيم المصروف بالتساوي بين المشاركين.
        final share = expense.amount / expense.splitWith.length;

        for (final participantId in expense.splitWith) {
          balances[participantId] = (balances[participantId] ?? 0) - share;
        }
      }
    }

    return balances;
  }

  List<Settlement> _createSettlements(
    List<_Balance> debtors,
    List<_Balance> creditors,
  ) {
    // تخزين الدفعات المطلوبة في النهاية.
    final settlements = <Settlement>[];

    // مؤشر الشخص المدين.
    var debtorIndex = 0;

    // مؤشر الشخص الدائن.
    var creditorIndex = 0;

    // تستمر العملية طالما يوجد أشخاص عليهم فلوس
    // ويوجد أشخاص لهم فلوس.
    while (debtorIndex < debtors.length && creditorIndex < creditors.length) {
      final debtor = debtors[debtorIndex];
      final creditor = creditors[creditorIndex];

      // يأخذ المبلغ الأصغر بين دين الشخص
      // وحق الشخص الآخر.
      final amount =
          debtor.amount < creditor.amount ? debtor.amount : creditor.amount;

      // إنشاء عملية تسديد جديدة:
      // هذا الشخص يدفع لهذا الشخص هذا المبلغ.
      settlements.add(
        Settlement(
          fromParticipantId: debtor.participantId,
          toParticipantId: creditor.participantId,
          amount: amount,
        ),
      );

      // تحديث المبلغ المتبقي على المدين بعد ما دفع.
      debtor.amount -= amount;

      // تحديث المبلغ المتبقي للدائن بعد ما استلم.
      creditor.amount -= amount;

      // إذا المدين خلص دينه،
      // ينتقل للمدين التالي.
      if (debtor.amount < 0.01) {
        debtorIndex++;
      }

      // إذا الدائن أخذ كامل المبلغ المستحق له،
      // ينتقل للدائن التالي.
      if (creditor.amount < 0.01) {
        creditorIndex++;
      }
    }

    return settlements;
  }
}

class _Balance {
  final String participantId;
  double amount;

  _Balance({
    required this.participantId,
    required this.amount,
  });
}
