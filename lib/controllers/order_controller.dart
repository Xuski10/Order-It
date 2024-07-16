import 'package:order_it_2/models/cart.dart';
import 'package:order_it_2/services/supabase_api.dart';

class OrderController {
  final SupabaseApi supabaseApi = SupabaseApi();

  // Los pedidos del usuario
  Future<List<Cart>> fetchOrders([String? userId]) async {
    try {
      final List<Map<String,dynamic>> cartData = 
          await supabaseApi.getOrders(userId);
      final List<Cart> carts = 
          cartData.map((cartData) => Cart.fromJson(cartData)).toList();
      
      return carts;
    } catch (e) {
      throw Exception('Error al traer el carrito del usuario: $e');
    }
  }
}