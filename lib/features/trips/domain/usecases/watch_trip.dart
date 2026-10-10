import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/domain/repositories/trip_repository.dart';

class WatchTripUseCase {
  final TripRepository repository;

  WatchTripUseCase({
    required this.repository,
  });

  Stream<Trip> call(String tripId) {
    return repository.watchTrip(tripId);
  }
}
