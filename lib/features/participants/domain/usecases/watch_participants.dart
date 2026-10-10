import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/participants/domain/repositories/participant_repository.dart';

class WatchParticipantsUseCase {
  final ParticipantRepository repository;

  WatchParticipantsUseCase({
    required this.repository,
  });

  Stream<List<Participant>> call(String tripId) {
    return repository.watchParticipants(tripId);
  }
}