class Category {
  final String id;
  final String nameKu;
  final String imageUrl;

  const Category({
    required this.id,
    required this.nameKu,
    required this.imageUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nameKu == other.nameKu &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => id.hashCode ^ nameKu.hashCode ^ imageUrl.hashCode;
}
