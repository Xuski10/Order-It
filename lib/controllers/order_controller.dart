import 'package:order_it_2/models/addon.dart';
import 'package:order_it_2/models/cart.dart';
import 'package:order_it_2/models/cart_item.dart';
import 'package:order_it_2/models/food.dart';
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

/// Obtiene todos los alimentos de un carrito específico.
/// 
/// Recupera los elementos del carrito para el carrito proporcionado,
/// luego obtiene los complementos y detalles de los alimentos para cada elemento del carrito.
/// 
/// Devuelve una lista de mapas que contienen los detalles de los alimentos,
/// incluyendo la cantidad y los complementos.
/// 
/// Lanza una excepción si falla la obtención de los elementos del carrito, complementos o detalles de los alimentos.
Future<List<Map<String, dynamic>>> fetchCartFoodDetails(String cartId) async {
  try {
    // Obtiene los elementos del carrito para el carrito proporcionado
    final List<Map<String, dynamic>> cartItems =
        await supabaseApi.fetchCartItems(cartId);
    
    // Convierte los datos de los elementos del carrito a objetos CartItem
    final List<CartItem> cartItem =
        cartItems.map((cartItems) => CartItem.fromJson(cartItems)).toList();
    
    List<Map<String, dynamic>> cartFood = [];

    // Itera sobre cada elemento del carrito
    for (var element in cartItem) {
      // Obtiene los complementos para cada elemento del carrito
      final List<Addon> cartItemsAddons =
          await supabaseApi.getFoodAddonsFromCart(element.id);

      // Obtiene los detalles de los alimentos (la tabla "food" trae la comida completa)
      var foodList = await supabaseApi.getFoodFromCart(element.foodId);

      // Agrega la cantidad y los complementos a cada alimento
      for (var food in foodList) {
        food['quantity'] = element.quantity;
        food['addons'] = cartItemsAddons.map((addon) => addon.toJson()).toList();
      }

      // Agrega los alimentos con cantidades y complementos a la lista cartFood
      cartFood.addAll(foodList);
    }

    return cartFood;
  } catch (e) {
    throw Exception('Error al cargar los pedidos del carrito: $e');
  }
}


/// Obtiene todos los alimentos para varios carritos.
/// 
/// Itera sobre cada carrito, recupera los elementos del carrito para cada uno,
/// y luego obtiene los detalles de los alimentos para cada elemento del carrito.
/// 
/// Devuelve una lista de objetos `Food` que representan todos los alimentos
/// asociados con los carritos proporcionados.
/// 
/// Lanza una excepción si falla la obtención de los elementos del carrito o los detalles de los alimentos.
Future<List<Food>> fetchFoodsForMultipleCarts(List<Cart> carts) async {
  try {
    final List<Food> allFoods = [];

    // Itera sobre cada carrito
    for (Cart cart in carts) {
      // Obtiene los elementos del carrito para el carrito actual
      final List<Map<String, dynamic>> cartItemData =
          await supabaseApi.fetchCartItems(cart.id);

      // Convierte los datos de los elementos del carrito a objetos CartItem
      final List<CartItem> cartItems =
          cartItemData.map((item) => CartItem.fromJson(item)).toList();

      // Obtiene los detalles de los alimentos para cada elemento del carrito
      for (CartItem cartItem in cartItems) {
        final List<Map<String, dynamic>> cartFoodData =
            await supabaseApi.getFood(foodId: cartItem.foodId);

        // Convierte los datos de los alimentos a objetos Food
        final List<Food> cartFoods =
            cartFoodData.map((food) => Food.fromJson(food)).toList();

        // Agrega todos los alimentos a la lista allFoods
        allFoods.addAll(cartFoods);
      }
    }

    return allFoods;
  } catch (error) {
    throw Exception('Error al obtener los elementos del carrito: $error');
  }
}


  
}