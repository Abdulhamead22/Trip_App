import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/domain/repositories/trip_repository.dart';

class WatchTripsUseCase {
  final TripRepository repository;

  WatchTripsUseCase({
    required this.repository,
  });

  Stream<List<Trip>> call() {
    return repository.watchTrips();
  }
}
