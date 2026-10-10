import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/features/auth/presentation/bindings/auth_binding.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/core/controllers/main_controller.dart';

import 'package:flutter_application_1/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:flutter_application_1/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:flutter_application_1/features/expenses/domain/repositories/expense_repository.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/add_expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/calculate_settlement.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/delete_expense.dart';
import 'package:flutter_application_1/features/expenses/domain/usecases/update_expense.dart';
import 'package:flutter_application_1/features/expenses/presentation/controllers/expense_controller.dart';

import 'package:flutter_application_1/features/participants/data/datasources/participant_remote_data_source.dart';
import 'package:flutter_application_1/features/participants/data/repositories/participant_repository_impl.dart';
import 'package:flutter_application_1/features/participants/domain/repositories/participant_repository.dart';
import 'package:flutter_application_1/features/participants/domain/usecases/add_participant.dart';
import 'package:flutter_application_1/features/participants/domain/usecases/watch_participants.dart';
import 'package:flutter_application_1/features/participants/presentation/controllers/participant_controller.dart';

import 'package:flutter_application_1/features/trips/data/datasource/trip_remote_data_source.dart';
import 'package:flutter_application_1/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:flutter_application_1/features/trips/domain/repositories/trip_repository.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/create_trip.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/watch_trip.dart';
import 'package:flutter_application_1/features/trips/domain/usecases/watch_trips.dart';
import 'package:flutter_application_1/features/trips/presentation/controllers/trip_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Main
    Get.put<MainController>(
      MainController(),
      permanent: true,
    );

    // Firebase
    Get.put<FirebaseFirestore>(
      FirebaseFirestore.instance,
      permanent: true,
    );

    Get.put<FirebaseAuth>(
      FirebaseAuth.instance,
      permanent: true,
    );
    // Authentication
    AuthBinding().dependencies();
    // Expenses
    Get.put<ExpenseRemoteDataSource>(
      ExpenseRemoteDataSource(
        firestore: Get.find<FirebaseFirestore>(),
      ),
      permanent: true,
    );

    Get.put<ExpenseRepository>(
      ExpenseRepositoryImpl(
        remoteDataSource: Get.find<ExpenseRemoteDataSource>(),
      ),
      permanent: true,
    );

    Get.put<AddExpenseUseCase>(
      AddExpenseUseCase(
        repository: Get.find<ExpenseRepository>(),
      ),
    );

    Get.put<UpdateExpenseUseCase>(
      UpdateExpenseUseCase(
        repository: Get.find<ExpenseRepository>(),
      ),
    );

    Get.put<DeleteExpenseUseCase>(
      DeleteExpenseUseCase(
        repository: Get.find<ExpenseRepository>(),
      ),
    );

    Get.put<CalculateSettlementUseCase>(
      CalculateSettlementUseCase(),
    );

    Get.put<ExpenseController>(
      ExpenseController(
        deleteExpenseUseCase: Get.find<DeleteExpenseUseCase>(),
        calculateSettlementUseCase: Get.find<CalculateSettlementUseCase>(),
      ),
      permanent: true,
    );

    // Participants
    Get.put<ParticipantRemoteDataSource>(
      ParticipantRemoteDataSource(
        firestore: Get.find<FirebaseFirestore>(),
      ),
      permanent: true,
    );

    Get.put<ParticipantRepository>(
      ParticipantRepositoryImpl(
        remoteDataSource: Get.find<ParticipantRemoteDataSource>(),
      ),
      permanent: true,
    );

    Get.put<AddParticipantUseCase>(
      AddParticipantUseCase(
        repository: Get.find<ParticipantRepository>(),
      ),
    );

    Get.put<WatchParticipantsUseCase>(
      WatchParticipantsUseCase(
        repository: Get.find<ParticipantRepository>(),
      ),
    );

    Get.put<ParticipantController>(
      ParticipantController(
        addParticipantUseCase: Get.find<AddParticipantUseCase>(),
        watchParticipantsUseCase: Get.find<WatchParticipantsUseCase>(),
      ),
      permanent: true,
    );

    // Trips
    Get.put<TripRemoteDataSource>(
      TripRemoteDataSource(
        firestore: Get.find<FirebaseFirestore>(),
        expenseDataSource: Get.find<ExpenseRemoteDataSource>(),
        participantDataSource: Get.find<ParticipantRemoteDataSource>(),
      ),
      permanent: true,
    );

    Get.put<TripRepository>(
      TripRepositoryImpl(
        remoteDataSource: Get.find<TripRemoteDataSource>(),
      ),
      permanent: true,
    );

    Get.put<CreateTripUseCase>(
      CreateTripUseCase(
        repository: Get.find<TripRepository>(),
      ),
    );

    Get.put<WatchTripsUseCase>(
      WatchTripsUseCase(
        repository: Get.find<TripRepository>(),
      ),
    );

    Get.put<WatchTripUseCase>(
      WatchTripUseCase(
        repository: Get.find<TripRepository>(),
      ),
    );

    Get.put<TripController>(
      TripController(
        createTripUseCase: Get.find<CreateTripUseCase>(),
        watchTripsUseCase: Get.find<WatchTripsUseCase>(),
        watchTripUseCase: Get.find<WatchTripUseCase>(),
      ),
      permanent: true,
    );
  }
}
