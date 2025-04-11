class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime validUntil;
  final int discount;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.validUntil,
    required this.discount,
  });
}
