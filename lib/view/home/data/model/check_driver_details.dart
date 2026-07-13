class CheckDriveDetails {
  final String driverId;
  final String board;
  final String phone;
  final String driver;
  final String photo;
  final int rate;
  final int ride;
  final String type;
  final String status;
  String? message;

  CheckDriveDetails({
    required this.driverId,
    required this.board,
    required this.phone,
    required this.driver,
    required this.photo,
    required this.rate,
    required this.ride,
    required this.type,
    required this.status,
    this.message
  });

  // Factory constructor for creating a new instance from JSON
  factory CheckDriveDetails.fromJson(Map<String, dynamic> json) {
    return CheckDriveDetails(
      driverId: json['driverId'].toString(),
      board: json['board'].toString(),
      phone: json['phone'].toString(),
      driver: json['driver'].toString(),
      photo: json['image'].toString(),
      rate: json['rate'],
      ride: json['ride'],
      type: json['type'],
      status: json['status'],
      message: json['message'].toString()
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'board': board,
      'phone': phone,
      'driver': driver,
      'photo': photo,
      'rate': rate,
      'ride': ride,
      'type': type,
      'status': status,
      'message' :message
    };
  }
}
