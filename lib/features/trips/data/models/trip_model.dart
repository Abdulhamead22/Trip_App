import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/expenses/domain/entities/expense.dart';
import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';

class TripModel extends Trip {
  const TripModel({
    required super.id,
    required super.name,
    required super.currency,
    required super.ownerId,
    required super.createdAt,
    required super.participants,
    required super.expenses,
  });

  factory TripModel.fromEntity(Trip trip) {
    return TripModel(
      id: trip.id,
      name: trip.name,
      currency: trip.currency,
      ownerId: trip.ownerId,
      createdAt: trip.createdAt,
      participants: trip.participants,
      expenses: trip.expenses,
    );
  }

  factory TripModel.fromMap(
    String id,
    Map<String, dynamic> map, {
    List<Participant> participants = const [],
    List<Expense> expenses = const [],
  }) {
    final timestamp = map['createdAt'] as Timestamp?;

    return TripModel(
      id: id,
      name: map['name'] as String? ?? '',
      currency: map['currency'] as String? ?? '₪',
      ownerId: map['ownerId'] as String? ?? '',
      createdAt: timestamp?.toDate() ?? DateTime.now(),
      participants: participants,
      expenses: expenses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'currency': currency,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
