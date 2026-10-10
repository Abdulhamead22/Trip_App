import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';

abstract class TripRepository {
  Future<void> createTrip(Trip trip);

  Stream<List<Trip>> watchTrips();

  Stream<Trip> watchTrip(String tripId);

  Future<void> updateTrip(Trip trip);

  Future<void> deleteTrip(String tripId);
}
