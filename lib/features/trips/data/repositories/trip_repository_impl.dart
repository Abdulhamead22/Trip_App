import 'package:flutter_application_1/features/trips/data/models/trip_model.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/data/datasource/trip_remote_data_source.dart';
import 'package:flutter_application_1/features/trips/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> createTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);

    await remoteDataSource.createTrip(model);
  }

  @override
  Stream<List<Trip>> watchTrips() {
    return remoteDataSource.watchTrips();
  }

  @override
  Stream<Trip> watchTrip(String tripId) {
    return remoteDataSource.watchTrip(tripId);
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    final model = TripModel.fromEntity(trip);

    await remoteDataSource.updateTrip(model);
  }

  @override
  Future<void> deleteTrip(String tripId) async {
    await remoteDataSource.deleteTrip(tripId);
  }
}