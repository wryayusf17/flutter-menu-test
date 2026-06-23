import '../entities/category.dart';
import '../repositories/menu_repository.dart';

class AddCategory {
  final MenuRepository repository;

  AddCategory(this.repository);

  Future<Category> call(Category category) async {
    return await repository.addCategory(category);
  }
}
