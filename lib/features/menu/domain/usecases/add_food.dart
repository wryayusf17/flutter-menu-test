import '../entities/food.dart';
import '../repositories/menu_repository.dart';

class AddFood {
  final MenuRepository repository;

  AddFood(this.repository);

  Future<Food> call(Food food) async {
    return await repository.addFood(food);
  }
}
