import 'dart:convert';

class MockApiClient {
  // Singleton pattern
  static final MockApiClient _instance = MockApiClient._internal();
  factory MockApiClient() => _instance;
  MockApiClient._internal();

  // Simulated Database State in raw JSON form
  final Map<String, dynamic> _database = {
    "categories": <Map<String, dynamic>>[
      {
        "id": "1",
        "name_ku": "ھەموو",
        "image_url":
            "https://img.icons8.com/color/96/pizza.png", // Fallback icon
      },
      {
        "id": "2",
        "name_ku": "پیتزا",
        "image_url": "https://img.icons8.com/color/96/pizza.png",
      },
      {
        "id": "3",
        "name_ku": "بەرگر",
        "image_url": "https://img.icons8.com/color/96/hamburger.png",
      },
      {
        "id": "4",
        "name_ku": "شاورمە",
        "image_url": "https://img.icons8.com/color/96/kebab.png",
      },
    ],
    "foods": <Map<String, dynamic>>[
      {
        "id": "101",
        "category_id": "4",
        "name_ku": "شاورمەی گۆشت",
        "description_ku": "بەرگری تایبەت و دۆبڵ پەنیەر",
        "price": 8000.0,
        "image_url":
            "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=600&auto=format&fit=crop",
      },
      {
        "id": "102",
        "category_id": "3",
        "name_ku": "بەرگر دۆبڵ پەنیەر",
        "description_ku": "بەرگری تایبەت و دۆبڵ پەنیەر",
        "price": 8000.0,
        "image_url":
            "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=600&auto=format&fit=crop",
      },
      {
        "id": "103",
        "category_id": "1", // Salad, shown in 'All'
        "name_ku": "زەڵاتەی ئەمریکی",
        "description_ku": "بەرگری تایبەت و دۆبڵ پەنیەر",
        "price": 8000.0,
        "image_url":
            "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=600&auto=format&fit=crop",
      },
    ],
  };

  // Helper to simulate network latency
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // GET /categories
  Future<String> getCategories() async {
    await _simulateNetworkDelay();
    return jsonEncode(_database["categories"]);
  }

  // GET /foods
  Future<String> getFoods() async {
    await _simulateNetworkDelay();
    return jsonEncode(_database["foods"]);
  }

  // POST /categories
  Future<String> addCategory(String categoryJson) async {
    await _simulateNetworkDelay();
    final Map<String, dynamic> categoryData = jsonDecode(categoryJson);

    // Auto-generate ID if missing
    if (categoryData["id"] == null || categoryData["id"].toString().isEmpty) {
      categoryData["id"] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final List<dynamic> categories = _database["categories"];
    categories.add(categoryData);

    return jsonEncode(categoryData);
  }

  // POST /foods
  Future<String> addFood(String foodJson) async {
    await _simulateNetworkDelay();
    final Map<String, dynamic> foodData = jsonDecode(foodJson);

    // Auto-generate ID if missing
    if (foodData["id"] == null || foodData["id"].toString().isEmpty) {
      foodData["id"] = DateTime.now().millisecondsSinceEpoch.toString();
    }

    final List<dynamic> foods = _database["foods"];
    foods.add(foodData);

    return jsonEncode(foodData);
  }

  // PUT /foods/:id
  Future<String> updateFood(String foodJson) async {
    await _simulateNetworkDelay();
    final Map<String, dynamic> updatedFood = jsonDecode(foodJson);
    final String id = updatedFood["id"].toString();

    final List<dynamic> foods = _database["foods"];
    final int index = foods.indexWhere(
      (element) => element["id"].toString() == id,
    );

    if (index != -1) {
      foods[index] = updatedFood;
      return jsonEncode(updatedFood);
    } else {
      throw Exception("Food item not found in mock database.");
    }
  }

  // DELETE /foods/:id
  Future<void> deleteFood(String id) async {
    await _simulateNetworkDelay();
    final List<dynamic> foods = _database["foods"];
    final int initialLength = foods.length;

    foods.removeWhere((element) => element["id"].toString() == id);

    if (foods.length == initialLength) {
      throw Exception("Food item not found in mock database.");
    }
  }
}
