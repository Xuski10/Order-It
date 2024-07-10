class Cart {
  String id;
  String userId;
  String price;
  bool isFinished;

  Cart({
    required this.id,
    required this.userId,
    required this.price,
    required this.isFinished
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      price: json['price'].toString(),
      isFinished: json['is_finished'] as bool
    );
  }

  Map<String,dynamic> toJson() {
    return {
      'id' : int.parse(id),
      'user_id': userId,
      'price': price,
      'is_finished': isFinished
    };
  }
}