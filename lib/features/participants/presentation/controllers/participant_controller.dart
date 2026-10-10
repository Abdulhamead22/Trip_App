import 'dart:async';

import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/participants/domain/usecases/add_participant.dart';
import 'package:flutter_application_1/features/participants/domain/usecases/watch_participants.dart';
import 'package:get/get.dart';

class ParticipantController extends GetxController {
  final AddParticipantUseCase addParticipantUseCase;
  final WatchParticipantsUseCase watchParticipantsUseCase;

  ParticipantController({
    required this.addParticipantUseCase,
    required this.watchParticipantsUseCase,
  });

  final RxList<Participant> participants = <Participant>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<List<Participant>>? _subscription;

  void watchParticipants(String tripId) {
    isLoading.value = true;
    errorMessage.value = '';

    _subscription?.cancel();

    _subscription = watchParticipantsUseCase(tripId).listen(
      (result) {
        participants.assignAll(result);
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        errorMessage.value = 'Failed to load participants';
      },
    );
  }

  Future<bool> addParticipant(
    String tripId,
    Participant participant,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await addParticipantUseCase(
        tripId,
        participant,
      );

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to add participant';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
