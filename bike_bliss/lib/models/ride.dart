class Ride {
  final String id;
  final String bikeName;
  final String bikeType;
  final DateTime startTime;
  final DateTime? endTime;
  final double? distance;
  final double? cost;
  final String startLocation;
  final String? endLocation;
  final String imageUrl;

  Ride({
    required this.id,
    required this.bikeName,
    required this.bikeType,
    required this.startTime,
    this.endTime,
    this.distance,
    this.cost,
    required this.startLocation,
    this.endLocation,
    required this.imageUrl,
  });
}
