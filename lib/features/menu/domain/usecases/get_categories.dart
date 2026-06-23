import '../entities/category.dart';
import '../repositories/menu_repository.dart';

class GetCategories {
  final MenuRepository repository;

  GetCategories(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}
