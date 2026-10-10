import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/trips/presentation/controllers/trip_controller.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/helpers/category_color.dart';
import 'package:flutter_application_1/core/helpers/category_icon.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/expenses/presentation/bindings/expense_binding.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:flutter_application_1/features/expenses/presentation/widgets/add_expense_screen.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:flutter_application_1/widgets/empty_state.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';
import 'package:get/get.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;

  const TripDetailsScreen({
    super.key,
    required this.trip,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final ExpenseController expenseController = Get.find<ExpenseController>();
  final controller = Get.find<TripController>();

  int selectedTab = 0;


@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    controller.watchTrip(widget.trip.id);
  });
}

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isTripLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final trip = controller.selectedTrip.value;

      if (trip == null) {
        return const Scaffold(
          body: Center(
            child: Text('Trip not found'),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Trip Details',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                _buildHeader(trip),
                const SizedBox(height: 20),
                _buildSummary(trip),
                const SizedBox(height: 22),
                _buildTabs(),
                const SizedBox(height: 18),
                Expanded(
                  child: _buildContent(trip),
                ),
                const SizedBox(height: 4),
                PrimaryButton(
                  height: 52,
                  text: '+ Add Expense',
                  onPressed: () {
                    Get.to(
                      () => AddExpenseScreen(
                        trip: trip,
                      ),
                      binding: ExpenseBinding(
                        trip: trip,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (selectedTab != 2)
                  PrimaryButton(
                    height: 52,
                    backgroundColor: AppColors.lightGreen,
                    text: 'Settle Up',
                    foregroundColor: AppColors.green,
                    onPressed: () {
                      setState(() {
                        selectedTab = 2;
                      });
                    },
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(Trip trip) {
    return Row(
      children: [
        IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.darkText,
            size: 25,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            trip.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(Trip trip) {
    return Container(
      width: double.infinity,
      height: 125,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${trip.total.toStringAsFixed(0)} ${trip.currency}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                  height: 1,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${trip.participants.length}',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                  height: 1,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'People',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const tabs = [
      'Expenses',
      'People',
      'Settlement',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        tabs.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedTab = index;
            });
          },
          child: Column(
            children: [
              Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selectedTab == index
                      ? AppColors.green
                      : AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 4),
              if (selectedTab == index)
                Container(
                  width: 32,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Trip trip) {
    switch (selectedTab) {
      case 0:
        return _buildExpenses(trip);

      case 1:
        return _buildPeople(trip);

      case 2:
        return _buildSettlement(trip);

      default:
        return _buildExpenses(trip);
    }
  }

  Widget _buildExpenses(Trip trip) {
    if (trip.expenses.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No expenses yet',
        message: 'Add your first expense to start tracking the trip.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: trip.expenses.length,
      itemBuilder: (_, index) {
        final expense = trip.expenses[index];

        return _expenseItem(
          expense: expense,
          trip: trip,
          title: expense.title,
          subtitle: 'Paid by ${_getPaymentNames(
            expense,
            trip,
          )}',
          amount: '${expense.amount.toStringAsFixed(0)} ${trip.currency}',
          icon: getCategoryIcon(expense.title),
          iconColor: getCategoryColor(expense.title),
        );
      },
    );
  }

  Widget _buildPeople(Trip trip) {
    if (trip.participants.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline,
        title: 'No people yet',
        message: 'Add participants to start splitting expenses.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: trip.participants.length,
      itemBuilder: (_, index) {
        final participant = trip.participants[index];

        return _personItem(participant.name);
      },
    );
  }

  Widget _buildSettlement(Trip trip) {
    final settlements = expenseController.calculateSettlement(trip);
    if (settlements.isEmpty) {
      return const Center(
        child: Text(
          'Everyone is settled up 🎉',
          style: TextStyle(
            color: AppColors.mutedText,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: settlements.length,
      itemBuilder: (_, index) {
        final settlement = settlements[index];

        final fromName = _getParticipantName(
          settlement.fromParticipantId,
          trip,
        );

        final toName = _getParticipantName(
          settlement.toParticipantId,
          trip,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$fromName → $toName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
              ),
              Text(
                '${settlement.amount.toStringAsFixed(0)} ${trip.currency}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _expenseItem({
    required Expense expense,
    required Trip trip,
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 82,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () async {
              await Get.to(
                () => AddExpenseScreen(
                  trip: trip,
                  expense: expense,
                ),
                binding: ExpenseBinding(
                  trip: trip,
                  expense: expense,
                ),
              );
            },
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.green,
              size: 21,
            ),
          ),
          IconButton(
            onPressed: () {
              customDialog(
                title: 'Delete Expense',
                context: context,
                content: Text(
                  'Are you sure you want to delete "${expense.title}"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      Get.back();

                      final success = await expenseController.deleteExpense(
                        trip.id,
                        expense.id,
                      );

                      if (!success) {
                        Get.snackbar(
                          'Error',
                          expenseController.errorMessage.value,
                        );
                      }
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _personItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.green,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getParticipantName(
    String participantId,
    Trip trip,
  ) {
    for (final participant in trip.participants) {
      if (participant.id == participantId) {
        return participant.name;
      }
    }

    return 'Unknown';
  }

  String _getPaymentNames(Expense expense, Trip trip) {
    final names = expense.payments.keys.map(
      (participantId) {
        return _getParticipantName(
          participantId,
          trip,
        );
      },
    ).toList();

    if (names.isEmpty) {
      return 'No payment';
    }

    return names.join(', ');
  }
}
