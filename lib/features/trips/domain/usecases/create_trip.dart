import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/domain/repositories/trip_repository.dart';

class CreateTripUseCase {
  final TripRepository repository;

  CreateTripUseCase({
    required this.repository,
  });

  Future<void> call(Trip trip) {
    return repository.createTrip(trip);
  }
}
