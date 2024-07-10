class Addon {
  final String id;
  final String name;
  final double price;

  Addon({
    required this.id,
    required this.name,
    required this.price
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'].toString(),
      name: json['name'],
      price: json['price'].toDouble()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : int.parse(id),
      'name' : name,
      'price' : price
    };
  }
}