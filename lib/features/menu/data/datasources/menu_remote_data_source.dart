import 'dart:convert';
import '../../../../core/network/mock_api_client.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';

abstract class MenuRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<FoodModel>> getFoods();
  Future<CategoryModel> addCategory(CategoryModel category);
  Future<FoodModel> addFood(FoodModel food);
  Future<FoodModel> updateFood(FoodModel food);
  Future<void> deleteFood(String id);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final MockApiClient mockApiClient;

  MenuRemoteDataSourceImpl({required this.mockApiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final responseStr = await mockApiClient.getCategories();
    final List<dynamic> jsonList = jsonDecode(responseStr);
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<FoodModel>> getFoods() async {
    final responseStr = await mockApiClient.getFoods();
    final List<dynamic> jsonList = jsonDecode(responseStr);
    return jsonList.map((json) => FoodModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    final categoryJson = jsonEncode(category.toJson());
    final responseStr = await mockApiClient.addCategory(categoryJson);
    return CategoryModel.fromJson(jsonDecode(responseStr));
  }

  @override
  Future<FoodModel> addFood(FoodModel food) async {
    final foodJson = jsonEncode(food.toJson());
    final responseStr = await mockApiClient.addFood(foodJson);
    return FoodModel.fromJson(jsonDecode(responseStr));
  }

  @override
  Future<FoodModel> updateFood(FoodModel food) async {
    final foodJson = jsonEncode(food.toJson());
    final responseStr = await mockApiClient.updateFood(foodJson);
    return FoodModel.fromJson(jsonDecode(responseStr));
  }

  @override
  Future<void> deleteFood(String id) async {
    await mockApiClient.deleteFood(id);
  }
}
