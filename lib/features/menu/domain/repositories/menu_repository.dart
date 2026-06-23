import '../entities/category.dart';
import '../entities/food.dart';

abstract class MenuRepository {
  Future<List<Category>> getCategories();
  Future<List<Food>> getFoods();
  Future<Category> addCategory(Category category);
  Future<Food> addFood(Food food);
  Future<Food> updateFood(Food food);
  Future<void> deleteFood(String id);
}
