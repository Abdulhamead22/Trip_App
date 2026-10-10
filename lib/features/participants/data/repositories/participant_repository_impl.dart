import 'package:flutter_application_1/features/participants/data/models/participant_model.dart';
import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/participants/data/datasources/participant_remote_data_source.dart';
import 'package:flutter_application_1/features/participants/domain/repositories/participant_repository.dart';

class ParticipantRepositoryImpl implements ParticipantRepository {
  final ParticipantRemoteDataSource remoteDataSource;

  ParticipantRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> addParticipant(
    String tripId,
    Participant participant,
  ) async {
    final model = ParticipantModel(
      id: participant.id,
      name: participant.name,
    );

    await remoteDataSource.addParticipant(
      tripId,
      model,
    );
  }

  @override
  Stream<List<Participant>> watchParticipants(
    String tripId,
  ) {
    return remoteDataSource.watchParticipants(tripId);
  }
}