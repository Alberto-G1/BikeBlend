class Bike {
  final String id;
  final String name;
  final String modelType;
  final String code;
  final String description;
  final double rating;
  final int likes;
  final double price;
  final String imageUrl;
  final List<String> features;
  final List<String> specifications;
  final bool isLiked;

  Bike({
    required this.id,
    required this.name,
    required this.modelType,
    required this.code,
    required this.description,
    required this.rating,
    required this.likes,
    required this.price,
    required this.imageUrl,
    required this.features,
    required this.specifications,
    this.isLiked = false,
  });

  Bike copyWith({
    String? id,
    String? name,
    String? modelType,
    String? code,
    String? description,
    double? rating,
    int? likes,
    double? price,
    String? imageUrl,
    List<String>? features,
    List<String>? specifications,
    bool? isLiked,
  }) {
    return Bike(
      id: id ?? this.id,
      name: name ?? this.name,
      modelType: modelType ?? this.modelType,
      code: code ?? this.code,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      likes: likes ?? this.likes,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      features: features ?? this.features,
      specifications: specifications ?? this.specifications,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
