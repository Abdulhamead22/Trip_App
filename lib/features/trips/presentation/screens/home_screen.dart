import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/controllers/main_controller.dart';
import 'package:flutter_application_1/features/trips/presentation/controllers/trip_controller.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/expenses/presentation/widgets/expense_summary.dart';
import 'package:flutter_application_1/features/trips/presentation/widgets/home_trips.dart';
import 'package:flutter_application_1/widgets/empty_state.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TripController>();
    final mainController = Get.find<MainController>();
    return Obx(() {
      if (controller.isLoading.value && controller.trips.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.errorMessage.value.isNotEmpty &&
          controller.trips.isEmpty) {
        return _buildErrorState(controller);
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'TripSplit',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Welcome back 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 38),
            ExpenseSummary(
              totalExpenses: controller.totalExpenses,
            ),
            const SizedBox(height: 35),
            controller.trips.isEmpty
                ? const EmptyState(
                    icon: Icons.luggage_outlined,
                    title: 'No trips yet',
                    message:
                        'Create your first trip and start tracking expenses.',
                  )
                : HomeTrips(
                    trips: controller.trips,
                    onSeeAll: () {
                      mainController.changeTab(
                        MainController.tripsIndex,
                      );
                    },
                  ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: '+ Create Trip',
              onPressed: () {
                mainController.changeTab(
                  MainController.addIndex,
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildErrorState(TripController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 50,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We could not load your trips.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: controller.watchTrips,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
