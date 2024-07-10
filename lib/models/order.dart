class Order {
  final int id;
  final String restaurantId;
  final String clientId;
  final String createdAt;
  final double? price;
  final bool isFinished;

  Order({
    required this.id,
    required this.restaurantId,
    required this.clientId,
    required this.createdAt,
    this.price,
    required this.isFinished,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurant_id'],
      clientId: json['client_id'],
      createdAt: json['created_at'],
      price: json['price'] != null ? json['price'].toDouble() : null,
      isFinished: json['is_finished'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'client_id': clientId,
      'created_at': createdAt,
      'price': price,
      'is_finished': isFinished,
    };
  }
}
