class Settlement {
  final String fromParticipantId;
  final String toParticipantId;
  final double amount;

  const Settlement({
    required this.fromParticipantId,
    required this.toParticipantId,
    required this.amount,
  });
}