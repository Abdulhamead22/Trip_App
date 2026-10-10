import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/presentation/screens/trip_details_screen.dart';
import 'package:flutter_application_1/features/trips/presentation/widgets/trip_card.dart';
import 'package:get/get.dart';

class HomeTrips extends StatelessWidget {
  final List<Trip> trips;
  final VoidCallback onSeeAll;
  const HomeTrips({
    super.key,
    required this.trips,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final recentTrips = trips.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Trips',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...recentTrips.map(
          (trip) => Padding(
            padding: const EdgeInsets.only(
              bottom: 14,
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
          ),
        ),
      ],
    );
  }
}
