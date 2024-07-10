import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:order_it_2/models/addon.dart';
import 'package:order_it_2/models/cart.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/models/food.dart';
import 'package:order_it_2/services/supabase_api.dart';
import 'package:order_it_2/utils/random_id.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Restaurant extends ChangeNotifier {
  final supabaseApi = SupabaseApi();
  final supabase = Supabase.instance.client;
  /*
    G E T T E R S
  */
  List<CartFood> get getUserCart => _cart;

  /*
    O P E R A T I O N S
  */
  // Carrito del usuario
  final List<CartFood> _cart = [];

  // Método para cargar los detalles del carrito
  Future<void> loadCartDetails() async {
    try {
      //_cart.clear();
      //List<CartFood> cartFoodList = await supabaseApi.getCartFoodDetails();
      _cart.addAll(_cart);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error al cargar los detalles del carrito: $e");
      }
    }
  }

  // Añadir al carrito
  Future<bool> addToCart(Food food, List<Addon>? selectedAddons) async {
    try {
      bool foodIsInCart = false;

      if (_cart.isNotEmpty) {
        for (var foodInCart in _cart) {         
          if (foodInCart.food.id == food.id) {
            foodIsInCart = true;
            foodInCart.quantity++;
          }
        }

        selectedAddons ?? _cart.first.addons;
      }

      if (_cart.isNotEmpty && !foodIsInCart) {
        nuevoCartItem(food, selectedAddons);
      }

      if (_cart.isEmpty) {
        _cart.add(CartFood(
            id: RandomIds.generateRandomId().toString(),
            food: food,
            addons: selectedAddons!,
            quantity: 1));
      }

      if (kDebugMode) {
        print(_cart);
      }

      await loadCartDetails();
      //notifyListeners();
      return true; // Indicar que se agregó correctamente al carrito
    } catch (e) {
      return false; // Si hay un error, devolver false
    }
  }

  void nuevoCartItem(Food food, List<Addon>? selectedAddons) {
    _cart.add(CartFood(
        id: RandomIds.generateRandomId().toString(),
        food: food,
        addons: selectedAddons!,
        quantity: 1));
  }

  // Eliminar del carrito
  Future<bool> removeFromCart(CartFood cartFood) async {
    if (cartFood.quantity < 1) return false;

    if (cartFood.quantity == 1) {
      _cart.remove(cartFood);
    }

    if (cartFood.quantity > 1) {
      cartFood.quantity--;
    }

    await loadCartDetails();
    notifyListeners();
    return true;
  }

  double getTotalPrice() {
    double total = 0.0;

    for (CartFood cartFood in _cart) {
      double itemTotal = cartFood.food.price;

      for (Addon addon in cartFood.addons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartFood.quantity;
    }

    return total;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartFood cartFood in _cart) {
      totalItemCount += cartFood.quantity;
    }

    return totalItemCount;
  }

  void clearCart() async {
    //final SupabaseApi supabase = SupabaseApi();
    //final cartId = await supabase.getCart();
    //await supabase.clearCart(cartId);

    _cart.clear();

    notifyListeners();
  }

  /*
    H E L P E R S
  */

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Aquí tienes tu recibo");
    receipt.writeln();

    String formattedData =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    receipt.writeln(formattedData);
    receipt.writeln();
    receipt.writeln("------------");

    for (final cartFood in _cart) {
      receipt.writeln(
          "${cartFood.quantity} x ${cartFood.food.name} - ${formatPrice(cartFood.food.price)}");
      if (cartFood.addons.isNotEmpty) {
        receipt.writeln(" Complementos: ${_formatAddons(cartFood.addons)}");
      }
      receipt.writeln();
    }

    receipt.writeln("------------");
    receipt.writeln();
    receipt.writeln("Cantidad total: ${getTotalItemCount()}");
    receipt.writeln("Precio total: ${formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  String formatPrice(double price) {
    return "${price.toStringAsFixed(2)} €";
  }

  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${formatPrice(addon.price)})")
        .join(", ");
  }
}
