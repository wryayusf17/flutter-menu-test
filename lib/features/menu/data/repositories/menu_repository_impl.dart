import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/food.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    try {
      return await remoteDataSource.getCategories();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<Food>> getFoods() async {
    try {
      return await remoteDataSource.getFoods();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Category> addCategory(Category category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      return await remoteDataSource.addCategory(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Food> addFood(Food food) async {
    try {
      final model = FoodModel.fromEntity(food);
      return await remoteDataSource.addFood(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Food> updateFood(Food food) async {
    try {
      final model = FoodModel.fromEntity(food);
      return await remoteDataSource.updateFood(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteFood(String id) async {
    try {
      await remoteDataSource.deleteFood(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
