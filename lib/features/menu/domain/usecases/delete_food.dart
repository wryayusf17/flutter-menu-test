import '../repositories/menu_repository.dart';

class DeleteFood {
  final MenuRepository repository;

  DeleteFood(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteFood(id);
  }
}
