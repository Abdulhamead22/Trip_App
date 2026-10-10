import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/participants/data/models/participant_model.dart';
import 'package:flutter_application_1/features/trips/data/models/trip_model.dart';
import 'package:flutter_application_1/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:flutter_application_1/features/expenses/data/models/expense_model.dart';
import 'package:flutter_application_1/features/participants/data/datasources/participant_remote_data_source.dart';

class TripRemoteDataSource {
  final FirebaseFirestore firestore;
  final ExpenseRemoteDataSource expenseDataSource;
  final ParticipantRemoteDataSource participantDataSource;

  TripRemoteDataSource({
    required this.firestore,
    required this.expenseDataSource,
    required this.participantDataSource,
  });

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Stream<List<TripModel>> watchTrips() {
    final userId = _currentUserId;

    if (userId == null) {
      return Stream.error(
        StateError('No authenticated user'),
      );
    }

    final controller = StreamController<List<TripModel>>();
    final tripsMap = <String, TripModel>{};
    final subscriptions = <String, List<StreamSubscription>>{};

    void emitTrips() {
      final result = tripsMap.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      controller.add(result);
    }

    void subscribeToTrip(TripModel trip) {
      TripModel latestTrip = trip;
      final tripId = trip.id;

      if (subscriptions.containsKey(tripId)) {
        final currentTrip = tripsMap[tripId];
        latestTrip = trip;
        if (currentTrip != null) {
          tripsMap[tripId] = TripModel(
            id: trip.id,
            name: trip.name,
            currency: trip.currency,
            ownerId: trip.ownerId,
            createdAt: trip.createdAt,
            participants: currentTrip.participants,
            expenses: currentTrip.expenses,
          );

          emitTrips();
        }

        return;
      }

      final participants = <ParticipantModel>[];
      final expenses = <ExpenseModel>[];
      final tripSubscriptions = <StreamSubscription>[];

      void updateTrip() {
        tripsMap[tripId] = TripModel(
          id: latestTrip.id,
          name: latestTrip.name,
          currency: latestTrip.currency,
          ownerId: latestTrip.ownerId,
          createdAt: latestTrip.createdAt,
          participants: List.from(participants),
          expenses: List.from(expenses),
        );

        emitTrips();
      }

      final participantsSubscription =
          participantDataSource.watchParticipants(tripId).listen(
        (result) {
          participants
            ..clear()
            ..addAll(result);

          updateTrip();
        },
        onError: controller.addError,
      );

      final expensesSubscription =
          expenseDataSource.watchExpenses(tripId).listen(
        (result) {
          expenses
            ..clear()
            ..addAll(result);

          updateTrip();
        },
        onError: controller.addError,
      );

      tripSubscriptions.add(participantsSubscription);
      tripSubscriptions.add(expensesSubscription);
      subscriptions[tripId] = tripSubscriptions;

      tripsMap[tripId] = TripModel(
        id: trip.id,
        name: trip.name,
        currency: trip.currency,
        ownerId: trip.ownerId,
        createdAt: trip.createdAt,
        participants: participants,
        expenses: expenses,
      );
    }

    final tripsSubscription = firestore
        .collection('trips')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .listen(
      (snapshot) {
        final currentTripIds = snapshot.docs.map((doc) => doc.id).toSet();

        for (final tripId in tripsMap.keys.toList()) {
          if (!currentTripIds.contains(tripId)) {
            tripsMap.remove(tripId);

            for (final subscription
                in subscriptions[tripId] ?? <StreamSubscription>[]) {
              subscription.cancel();
            }

            subscriptions.remove(tripId);
          }
        }

        for (final tripDoc in snapshot.docs) {
          final trip = TripModel.fromMap(
            tripDoc.id,
            tripDoc.data(),
          );

          subscribeToTrip(trip);
        }

        emitTrips();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await tripsSubscription.cancel();

      for (final tripSubscriptions in subscriptions.values) {
        for (final subscription in tripSubscriptions) {
          await subscription.cancel();
        }
      }

      subscriptions.clear();
    };

    return controller.stream;
  }

  Stream<TripModel> watchTrip(String tripId) {
    final userId = _currentUserId;

    if (userId == null) {
      return Stream.error(
        StateError('No authenticated user'),
      );
    }

    final tripRef = firestore.collection('trips').doc(tripId);
    final controller = StreamController<TripModel>();

    TripModel? trip;
    List<ParticipantModel> participants = [];
    List<ExpenseModel> expenses = [];

    void emitTrip() {
      if (trip == null || trip!.ownerId != userId) {
        return;
      }

      controller.add(
        TripModel(
          id: trip!.id,
          name: trip!.name,
          currency: trip!.currency,
          ownerId: trip!.ownerId,
          createdAt: trip!.createdAt,
          participants: List.from(participants),
          expenses: List.from(expenses),
        ),
      );
    }

    final tripSubscription = tripRef.snapshots().listen(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          controller.addError(Exception('Trip not found'));
          return;
        }

        final loadedTrip = TripModel.fromMap(
          snapshot.id,
          snapshot.data()!,
        );

        if (loadedTrip.ownerId != userId) {
          controller.addError(
            Exception('You do not have access to this trip'),
          );
          return;
        }

        trip = loadedTrip;
        emitTrip();
      },
      onError: controller.addError,
    );

    final participantsSubscription =
        participantDataSource.watchParticipants(tripId).listen(
      (result) {
        participants = result;
        emitTrip();
      },
      onError: controller.addError,
    );

    final expensesSubscription = expenseDataSource.watchExpenses(tripId).listen(
      (result) {
        expenses = result;
        emitTrip();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await tripSubscription.cancel();
      await participantsSubscription.cancel();
      await expensesSubscription.cancel();
    };

    return controller.stream;
  }

  Future<void> createTrip(TripModel trip) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw StateError('No authenticated user');
    }

    final tripDoc = firestore.collection('trips').doc();
    final tripData = trip.toMap();

    tripData['ownerId'] = userId;

    await tripDoc.set(tripData);

    for (final participant in trip.participants) {
      final participantDoc = tripDoc.collection('participants').doc();

      final participantModel = ParticipantModel(
        id: participantDoc.id,
        name: participant.name,
      );

      await participantDoc.set(participantModel.toMap());
    }
  }

  Future<void> updateTrip(TripModel trip) async {
    final userId = _currentUserId;

    if (userId == null) {
      throw StateError('No authenticated user');
    }

    await firestore.collection('trips').doc(trip.id).update({
      'name': trip.name,
      'currency': trip.currency,
    });
  }

  Future<void> deleteTrip(String tripId) async {
    if (_currentUserId == null) {
      throw StateError('No authenticated user');
    }

    await firestore.collection('trips').doc(tripId).delete();
  }
}
