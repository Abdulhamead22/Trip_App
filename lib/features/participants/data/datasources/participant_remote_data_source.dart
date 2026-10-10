import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/features/participants/data/models/participant_model.dart';

class ParticipantRemoteDataSource {
  final FirebaseFirestore firestore;

  ParticipantRemoteDataSource({
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> _participantsCollection(
    String tripId,
  ) {
    return firestore.collection('trips').doc(tripId).collection('participants');
  }

  Stream<List<ParticipantModel>> watchParticipants(
    String tripId,
  ) {
    return _participantsCollection(tripId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParticipantModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }

  Future<void> addParticipant(
    String tripId,
    ParticipantModel participant,
  ) async {
    await _participantsCollection(tripId).doc(participant.id).set(
          participant.toMap(),
        );
  }
}
