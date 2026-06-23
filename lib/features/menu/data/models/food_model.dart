import '../../domain/entities/food.dart';

class FoodModel extends Food {
  const FoodModel({
    required super.id,
    required super.categoryId,
    required super.nameKu,
    required super.descriptionKu,
    required super.price,
    required super.imageUrl,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      nameKu: json['name_ku']?.toString() ?? '',
      descriptionKu: json['description_ku']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name_ku': nameKu,
      'description_ku': descriptionKu,
      'price': price,
      'image_url': imageUrl,
    };
  }

  factory FoodModel.fromEntity(Food entity) {
    return FoodModel(
      id: entity.id,
      categoryId: entity.categoryId,
      nameKu: entity.nameKu,
      descriptionKu: entity.descriptionKu,
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
  }
}
