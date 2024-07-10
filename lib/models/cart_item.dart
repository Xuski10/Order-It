class CartItem {
  final String id;
  final String cartId;
  final String foodId;
  final int quantity;
  final bool served;

  CartItem({
    required this.id,
    required this.cartId,
    required this.foodId,
    required this.quantity,
    required this.served
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      cartId: json['cart_id'].toString(),
      foodId: json['food_id'].toString(),
      quantity: json['quantity'] as int,
      served: json['served'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cart_id': cartId,
      'food_id': foodId,
      'quantity': quantity,
      'served' : served
    };
  }
}