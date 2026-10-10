class Expense {
  final String id;
  final String title;
  final double amount;
  final Map<String, double> payments;
  final List<String> splitWith;
  final Map<String, double> splitAmounts;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.payments,
    required this.splitWith,
    required this.splitAmounts,
    required this.createdAt,
  });
}
