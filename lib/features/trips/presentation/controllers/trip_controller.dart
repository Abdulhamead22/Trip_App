import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/create_trip.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/watch_trips.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/watch_trip.dart';
import 'package:get/get.dart';

class TripController extends GetxController {
  final CreateTripUseCase createTripUseCase;
  final WatchTripsUseCase watchTripsUseCase;
  final WatchTripUseCase watchTripUseCase;

  TripController({
    required this.createTripUseCase,
    required this.watchTripsUseCase,
    required this.watchTripUseCase,
  });

  final RxList<Trip> trips = <Trip>[].obs;

  final Rx<Trip?> selectedTrip = Rx<Trip?>(null);

  final RxBool isLoading = false.obs;

  final RxBool isTripLoading = false.obs;
  final RxString errorMessage = ''.obs;
  StreamSubscription<User?>? _authSubscription;
  String? _lastUserId;

  StreamSubscription<List<Trip>>? _tripsSubscription;
  StreamSubscription<Trip>? _tripSubscription;

  double get totalExpenses {
    return trips.fold<double>(
      0,
      (sum, trip) => sum + trip.total,
    );
  }

  @override
  void onInit() {
    super.onInit();

    _lastUserId = FirebaseAuth.instance.currentUser?.uid;

    watchTrips();

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      final newUserId = user?.uid;

      if (_lastUserId == newUserId) return;

      _lastUserId = newUserId;

      _tripsSubscription?.cancel();
      _tripSubscription?.cancel();

      trips.clear();
      selectedTrip.value = null;

      if (newUserId != null) {
        watchTrips();
      } else {
        isLoading.value = false;
        isTripLoading.value = false;
      }
    });
  }

  void watchTrips() {
    isLoading.value = true;
    errorMessage.value = '';

    _tripsSubscription?.cancel();

    _tripsSubscription = watchTripsUseCase().listen(
      (result) {
        trips.assignAll(result);
        isLoading.value = false;

        _updateSelectedTrip(result);
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Failed to load trips';
      },
    );
  }

  void _updateSelectedTrip(List<Trip> trips) {
    final currentTrip = selectedTrip.value;

    if (currentTrip == null) {
      return;
    }

    for (final trip in trips) {
      if (trip.id == currentTrip.id) {
        selectedTrip.value = trip;
        return;
      }
    }

    selectedTrip.value = null;
  }

  Future<bool> createTrip(Trip trip) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await createTripUseCase(trip);

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to create trip';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void watchTrip(String tripId) {
    isTripLoading.value = true;
    errorMessage.value = '';

    _tripSubscription?.cancel();

    _tripSubscription = watchTripUseCase(tripId).listen(
      (trip) {
        selectedTrip.value = trip;
        isTripLoading.value = false;
      },
      onError: (error) {
        isTripLoading.value = false;
        errorMessage.value = 'Failed to load trip';
      },
    );
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _tripsSubscription?.cancel();
    _tripSubscription?.cancel();
    super.onClose();
  }
}
