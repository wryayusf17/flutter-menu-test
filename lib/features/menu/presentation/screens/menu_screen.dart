import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/menu_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_selector.dart';
import '../widgets/food_grid.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_edit_food_dialog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentNavIndex = 1; // Middle index (Menu) is active by default

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadMenu();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MenuProvider>();

    return Directionality(
      textDirection: TextDirection.rtl, // Ensure RTL for Kurdish Layout
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: provider.isLoading && provider.categories.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => provider.loadMenu(),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Search Bar
                      const CustomSearchBar(),
                      const SizedBox(height: 20),

                      // 2. Action Buttons (Add Food & Add Category)
                      _buildActionButtonsRow(),
                      const SizedBox(height: 24),

                      // 3. Category Selector
                      const CategorySelector(),
                      const SizedBox(height: 24),

                      // 4. Food Items Grid
                      if (provider.isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      else if (provider.errorMessage != null)
                        _buildErrorState(provider)
                      else
                        const FoodGrid(),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Header/AppBar Custom Implementation matching Screenshot
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: const Text(
        'ڕێستۆرانتەکەم',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Bell/Notification icon on the left (represented as leading in RTL)
      leading: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textDark,
                  size: 26,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('سەبەتەی کڕین بەتاڵە')),
                  );
                },
              ),
              // Tiny Green Notification Badge Dot
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Cart/Bag icon on the right (represented as actions in RTL)
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textDark,
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('هیچ ئاگادارییەک نییە')),
              );
            },
          ),
        ),
      ],
    );
  }

  // Row containing Add Food and Add Category buttons
  Widget _buildActionButtonsRow() {
    return Row(
      children: [
        // Right Action: Add Food Button (filled green)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddEditFoodDialog(),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 22,
            ),
            label: const Text(
              'زیادکردنی خواردن',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Left Action: Add Category Button (white background, green borders)
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddCategoryDialog(),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
              size: 22,
            ),
            label: const Text(
              'زیادکردنی بەش',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Bottom Navigation Bar with 3 sections: [List, Menu, Profile]
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        backgroundColor: Colors.white,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 26),
            label: 'پرۆفایل',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu, size: 26),
            label: 'مینو',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined, size: 26),
            label: 'داواکارییەکان',
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(MenuProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: 12),
            Text(
              'خەتا لە بارکردنی زانیارییەکان:\n${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadMenu(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'دووبارە ھەوڵبدەرەوە',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
