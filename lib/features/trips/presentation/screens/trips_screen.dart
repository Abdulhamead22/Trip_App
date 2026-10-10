import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/controllers/main_controller.dart';
import 'package:flutter_application_1/widgets/empty_state.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/features/trips/presentation/controllers/trip_controller.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';
import 'package:flutter_application_1/features/trips/presentation/widgets/trip_card.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final searchController = TextEditingController();
  final mainController = Get.find<MainController>();
  final TripController tripController = Get.find<TripController>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trips',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mutedText,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Trips',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
            ),
          ),

          const SizedBox(height: 20),

          // Search
          CustomTextField(
            controller: searchController,
            hintText: 'Search trips...',
            prefixIcon: Icons.search_rounded,
            onChange: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          // Create Trip
          PrimaryButton(
            text: '+ Create Trip',
            onPressed: () {
              mainController.changeTab(
                MainController.addIndex,
              );
            },
          ),

          const SizedBox(height: 24),

          // Trips
          Obx(
            () {
              if (tripController.isLoading.value &&
                  tripController.trips.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (tripController.errorMessage.value.isNotEmpty &&
                  tripController.trips.isEmpty) {
                return Center(
                  child: Text(
                    tripController.errorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              final query = searchController.text.toLowerCase();

              final trips = tripController.trips
                  .where(
                    (trip) => trip.name.toLowerCase().contains(query),
                  )
                  .toList();

              if (trips.isEmpty) {
                return EmptyState(
                  icon: query.isEmpty
                      ? Icons.luggage_outlined
                      : Icons.search_off_rounded,
                  title: query.isEmpty ? 'No trips yet' : 'No trips found',
                  message: query.isEmpty
                      ? 'Create your first trip and start tracking expenses.'
                      : 'Try a different search term.',
                );
              }

              return Column(
                children: trips.map(
                  (trip) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: TripCard(
                        trip: trip,
                        onTap: () {
                          Get.to(
                            () => TripDetailsScreen(
                              trip: trip,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
