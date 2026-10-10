import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';

abstract class ParticipantRepository {
  Future<void> addParticipant(
    String tripId,
    Participant participant,
  );

  Stream<List<Participant>> watchParticipants(
    String tripId,
  );
}