/// State for device migration cubit
abstract class DeviceMigrationState {
  const DeviceMigrationState();
}

class DeviceMigrationInitial extends DeviceMigrationState {
  const DeviceMigrationInitial();
}

class DeviceMigrationLoading extends DeviceMigrationState {
  const DeviceMigrationLoading();
}

class DeviceMigrationReady extends DeviceMigrationState {
  final String sessionId;
  final DateTime expiresAt;

  const DeviceMigrationReady({
    required this.sessionId,
    required this.expiresAt,
  });
}

class DeviceMigrationAwaitingConfirmation extends DeviceMigrationState {
  final String? targetDeviceId;
  final String? targetPublicKey;

  const DeviceMigrationAwaitingConfirmation({
    this.targetDeviceId,
    this.targetPublicKey,
  });
}

class DeviceMigrationTransferring extends DeviceMigrationState {
  const DeviceMigrationTransferring();
}

class DeviceMigrationCompleted extends DeviceMigrationState {
  const DeviceMigrationCompleted();
}

class DeviceMigrationError extends DeviceMigrationState {
  final String message;

  const DeviceMigrationError(this.message);
}
