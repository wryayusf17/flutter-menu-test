import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/network/mock_api_client.dart';
import 'features/menu/data/datasources/menu_remote_data_source.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/usecases/add_category.dart';
import 'features/menu/domain/usecases/add_food.dart';
import 'features/menu/domain/usecases/delete_food.dart';
import 'features/menu/domain/usecases/get_categories.dart';
import 'features/menu/domain/usecases/get_foods.dart';
import 'features/menu/domain/usecases/update_food.dart';
import 'features/menu/presentation/providers/menu_provider.dart';
import 'features/menu/presentation/screens/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Dependency Injection setup (Clean Architecture graph construction)
  final mockApiClient = MockApiClient();
  final remoteDataSource = MenuRemoteDataSourceImpl(mockApiClient: mockApiClient);
  final repository = MenuRepositoryImpl(remoteDataSource: remoteDataSource);
  
  final getCategories = GetCategories(repository);
  final getFoods = GetFoods(repository);
  final addCategory = AddCategory(repository);
  final addFood = AddFood(repository);
  final updateFood = UpdateFood(repository);
  final deleteFood = DeleteFood(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MenuProvider(
            getCategoriesUseCase: getCategories,
            getFoodsUseCase: getFoods,
            addCategoryUseCase: addCategory,
            addFoodUseCase: addFood,
            updateFoodUseCase: updateFood,
            deleteFoodUseCase: deleteFood,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ڕێستۆرانتەکەم',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        // Premium default font styling
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const MenuScreen(),
    );
  }
}
