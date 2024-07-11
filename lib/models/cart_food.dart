import 'package:order_it_2/models/addon.dart';
import 'package:order_it_2/models/food.dart';

class CartFood {
  String id;
  Food food;
  List<Addon> addons;
  int quantity;

  CartFood({
    required this.id,
    required this.food,
    required this.addons,
    required this.quantity,
  });

  factory CartFood.fromJson(Map<String, dynamic> json) {
    return CartFood(
      id: json['id'].toString(),
      food: Food.fromJson(json['food']),
      addons: (json['addons'] as List<dynamic>)
          .map((addonJson) => Addon.fromJson(addonJson))
          .toList(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'addons': addons.map((addon) => addon.toJson()).toList(),
      'quantity': quantity,
    };
  }
}
