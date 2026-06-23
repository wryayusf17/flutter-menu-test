import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/food.dart';
import '../providers/menu_provider.dart';

class AddEditFoodDialog extends StatefulWidget {
  final Food? food; // If null, we are adding. If not null, we are editing.

  const AddEditFoodDialog({super.key, this.food});

  @override
  State<AddEditFoodDialog> createState() => _AddEditFoodDialogState();
}

class _AddEditFoodDialogState extends State<AddEditFoodDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  String? _selectedCategoryId;

  bool get isEditing => widget.food != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food?.nameKu ?? '');
    _descriptionController = TextEditingController(text: widget.food?.descriptionKu ?? 'بەرگری تایبەت و دۆبڵ پەنیەر');
    _priceController = TextEditingController(
      text: widget.food != null ? widget.food!.price.toStringAsFixed(0) : '',
    );
    _imageController = TextEditingController(text: widget.food?.imageUrl ?? '');
    
    final provider = context.read<MenuProvider>();
    if (widget.food != null) {
      _selectedCategoryId = widget.food!.categoryId;
    } else if (provider.categories.isNotEmpty) {
      // Don't select "1" (All/ھەموو) as a default category for a new food
      final selectable = provider.categories.where((c) => c.id != "1").toList();
      if (selectable.isNotEmpty) {
        _selectedCategoryId = selectable.first.id;
      } else {
        _selectedCategoryId = provider.categories.first.id;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MenuProvider>();
    // Exclude "All" category from dropdown selection
    final dropdownCategories = provider.categories.where((c) => c.id != "1").toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isEditing ? 'دەستکاری خواردن' : 'زیادکردنی خواردن',
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category Dropdown
                if (dropdownCategories.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'بەش',
                      labelStyle: const TextStyle(color: AppColors.textLight),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    items: dropdownCategories.map((c) {
                      return DropdownMenuItem<String>(
                        value: c.id,
                        child: Text(c.nameKu),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoryId = val;
                      });
                    },
                    validator: (val) => val == null ? 'تکایە بەشێک ھەڵبژێرە' : null,
                  ),
                  const SizedBox(height: 16),
                ],
                // Food Name Field
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration('ناوی خواردن'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'ناوی خواردن پێویستە' : null,
                ),
                const SizedBox(height: 16),
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration('پێناسە / ڕوونکردنەوە'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'پێناسە پێویستە' : null,
                ),
                const SizedBox(height: 16),
                // Price Field
                TextFormField(
                  controller: _priceController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration('نرخ (دینار)'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'نرخ پێویستە';
                    }
                    if (double.tryParse(value) == null) {
                      return 'تکایە نرخێکی دروست بنووسە';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Image URL Field
                TextFormField(
                  controller: _imageController,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration('بەستەری وێنە (بەتاڵ بێت وێنەی بنەڕەتی بەکاردێت)'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'پاشگەزبوونەوە',
              style: TextStyle(color: AppColors.textLight),
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              isEditing ? 'دەستکاریکردن' : 'زیادکردن',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 2),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<MenuProvider>();
      final name = _nameController.text.trim();
      final desc = _descriptionController.text.trim();
      final price = double.parse(_priceController.text.trim());
      final imgUrl = _imageController.text.trim();
      final categoryId = _selectedCategoryId ?? "1";

      bool success;
      if (isEditing) {
        final updatedFood = Food(
          id: widget.food!.id,
          categoryId: categoryId,
          nameKu: name,
          descriptionKu: desc,
          price: price,
          imageUrl: imgUrl.isNotEmpty ? imgUrl : widget.food!.imageUrl,
        );
        success = await provider.updateFood(updatedFood);
      } else {
        success = await provider.addFood(
          nameKu: name,
          descriptionKu: desc,
          price: price,
          categoryId: categoryId,
          imageUrl: imgUrl,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        final actionText = isEditing ? 'دەستکاریکرا' : 'زیادکرا';
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خواردنی "$name" بە سەرکەوتوویی $actionText'),
              backgroundColor: AppColors.primary,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('کردارەکە شکستخواردوو بوو: ${provider.actionError}'),
              backgroundColor: AppColors.red,
            ),
          );
        }
      }
    }
  }
}
