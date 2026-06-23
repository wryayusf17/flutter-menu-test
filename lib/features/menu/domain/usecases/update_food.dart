import '../entities/food.dart';
import '../repositories/menu_repository.dart';

class UpdateFood {
  final MenuRepository repository;

  UpdateFood(this.repository);

  Future<Food> call(Food food) async {
    return await repository.updateFood(food);
  }
}
