import 'package:order_it_2/models/food_category.dart';
import 'package:order_it_2/services/supabase_api.dart';

class FoodCategoryController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<FoodCategory>> fetchCategories() async {
    try {
      final List<Map<String, dynamic>> categoriesData = 
          await supabaseApi.getCategories();
      final List<FoodCategory> categories = categoriesData
          .map((categoriesData) => FoodCategory.fromJson(categoriesData))
          .toList();
      return categories;
    } catch (e) {
      throw Exception('Error al traer las categorías: $e');
    }
  }
}