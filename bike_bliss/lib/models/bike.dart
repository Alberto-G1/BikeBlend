class Bike {
  final String id;
  final String name;
  final String type;
  final double distance;
  final int? batteryLevel;
  final double pricePerMinute;
  final String imageUrl;
  final String location;

  Bike({
    required this.id,
    required this.name,
    required this.type,
    required this.distance,
    this.batteryLevel,
    required this.pricePerMinute,
    required this.imageUrl,
    required this.location,
  });
}
