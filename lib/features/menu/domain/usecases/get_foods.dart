import '../entities/food.dart';
import '../repositories/menu_repository.dart';

class GetFoods {
  final MenuRepository repository;

  GetFoods(this.repository);

  Future<List<Food>> call() async {
    return await repository.getFoods();
  }
}
