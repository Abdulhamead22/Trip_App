import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';

class ParticipantModel extends Participant {
  const ParticipantModel({
    required super.id,
    required super.name,
  });

  factory ParticipantModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return ParticipantModel(
      id: id,
      name: map['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
