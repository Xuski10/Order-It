import 'package:order_it_2/models/food.dart';
import 'package:order_it_2/services/supabase_api.dart';

class FoodController {

  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Food>> fetchAllFood() async {
    try {
      // Obtenemos los datos de Food en formato JSON
      final List<Map<String, dynamic>> foodData = await supabaseApi.getFood();

      // Convertimos el JSON en objetos Food
      final List<Food> foods = foodData.map((data) => Food.fromJson(data)).toList();

      // 
    } catch {

    }
  }
}