import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/food.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/add_food.dart';
import '../../domain/usecases/delete_food.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_foods.dart';
import '../../domain/usecases/update_food.dart';

class MenuProvider extends ChangeNotifier {
  final GetCategories getCategoriesUseCase;
  final GetFoods getFoodsUseCase;
  final AddCategory addCategoryUseCase;
  final AddFood addFoodUseCase;
  final UpdateFood updateFoodUseCase;
  final DeleteFood deleteFoodUseCase;

  List<Category> _categories = [];
  List<Food> _foods = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _actionError;
  String _selectedCategoryId = "1"; // Default "1" is "ھەموو" (All)
  String _searchQuery = "";

  MenuProvider({
    required this.getCategoriesUseCase,
    required this.getFoodsUseCase,
    required this.addCategoryUseCase,
    required this.addFoodUseCase,
    required this.updateFoodUseCase,
    required this.deleteFoodUseCase,
  });

  // Getters
  List<Category> get categories => _categories;
  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get actionError => _actionError;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  // Filtered foods list based on category and search query
  List<Food> get filteredFoods {
    return _foods.where((food) {
      final matchesCategory = _selectedCategoryId == "1" || food.categoryId == _selectedCategoryId;
      final matchesSearch = food.nameKu.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          food.descriptionKu.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Setters & state management updates
  void setSelectedCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Load Categories and Foods
  Future<void> loadMenu() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final categoriesResult = await getCategoriesUseCase();
      final foodsResult = await getFoodsUseCase();
      
      _categories = categoriesResult;
      _foods = foodsResult;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Category
  Future<bool> addCategory(String nameKu) async {
    _isLoading = true;
    _actionError = null;
    notifyListeners();
    try {
      final newCategory = Category(
        id: "", // Client leaves empty; Mock API server generates it
        nameKu: nameKu,
        imageUrl: "https://img.icons8.com/color/96/kebab.png", // Generic food category icon
      );
      final savedCategory = await addCategoryUseCase(newCategory);
      _categories.add(savedCategory);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add Food
  Future<bool> addFood({
    required String nameKu,
    required String descriptionKu,
    required double price,
    required String categoryId,
    required String imageUrl,
  }) async {
    _isLoading = true;
    _actionError = null;
    notifyListeners();
    try {
      final newFood = Food(
        id: "", // Client leaves empty; Mock API server generates it
        categoryId: categoryId,
        nameKu: nameKu,
        descriptionKu: descriptionKu,
        price: price,
        imageUrl: imageUrl.isNotEmpty 
            ? imageUrl 
            : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=600&auto=format&fit=crop", // Default delicious fallback
      );
      final savedFood = await addFoodUseCase(newFood);
      _foods.add(savedFood);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update Food
  Future<bool> updateFood(Food food) async {
    _isLoading = true;
    _actionError = null;
    notifyListeners();
    try {
      final updated = await updateFoodUseCase(food);
      final index = _foods.indexWhere((element) => element.id == food.id);
      if (index != -1) {
        _foods[index] = updated;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete Food
  Future<bool> deleteFood(String id) async {
    _isLoading = true;
    _actionError = null;
    notifyListeners();
    try {
      await deleteFoodUseCase(id);
      _foods.removeWhere((element) => element.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _actionError = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
