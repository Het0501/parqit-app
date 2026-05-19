class ParkingLot {
  final String id;
  final String name;
  final String address;
  final String distance;
  final int pricePerHour;
  final int totalSlots;
  final int availableSlots;

  ParkingLot({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.pricePerHour,
    required this.totalSlots,
    required this.availableSlots,
  });
}
