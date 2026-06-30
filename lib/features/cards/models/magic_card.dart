class MagicCard {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> colorIdentity;

  const MagicCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.colorIdentity,
  });

  factory MagicCard.fromScryfallJson(Map<String, dynamic> json) {
    final imageUris = json['image_uris'] as Map<String, dynamic>?;
    final cardFaces = json['card_faces'] as List<dynamic>?;

    String? imageUrl;

    if (imageUris != null) {
      imageUrl = imageUris['normal'] as String?;
    } else if (cardFaces != null && cardFaces.isNotEmpty) {
      final firstFace = cardFaces.first as Map<String, dynamic>;
      final firstFaceImageUris =
          firstFace['image_uris'] as Map<String, dynamic>?;
      imageUrl = firstFaceImageUris?['normal'] as String?;
    }

    return MagicCard(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: imageUrl,
      colorIdentity: (json['color_identity'] as List<dynamic>? ?? [])
          .map((color) => color as String)
          .toList(),
    );
  }
}
