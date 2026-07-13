class CheckDriveError {
  final String message;
  final int? rideId;

  CheckDriveError({
    required this.message,
    required this.rideId,
  });

  factory CheckDriveError.fromJson(Map<String, dynamic> json) {
    return CheckDriveError(
      message: json['message'] as String,
      rideId: json['id'] as int?,
    );
  }

  @override
  String toString() {
    return 'CheckDriveError: {message: $message, driveId: $rideId}';
  }
}
