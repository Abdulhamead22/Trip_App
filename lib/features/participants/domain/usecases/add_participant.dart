import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/participants/domain/repositories/participant_repository.dart';

class AddParticipantUseCase {
  final ParticipantRepository repository;

  AddParticipantUseCase({
    required this.repository,
  });

  Future<void> call(
    String tripId,
    Participant participant,
  ) async {
    await repository.addParticipant(
      tripId,
      participant,
    );
  }
}
