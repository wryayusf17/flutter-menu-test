class Food {
  final String id;
  final String categoryId;
  final String nameKu;
  final String descriptionKu;
  final double price;
  final String imageUrl;

  const Food({
    required this.id,
    required this.categoryId,
    required this.nameKu,
    required this.descriptionKu,
    required this.price,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          categoryId == other.categoryId &&
          nameKu == other.nameKu &&
          descriptionKu == other.descriptionKu &&
          price == other.price &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      categoryId.hashCode ^
      nameKu.hashCode ^
      descriptionKu.hashCode ^
      price.hashCode ^
      imageUrl.hashCode;
}
