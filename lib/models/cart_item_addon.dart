class CartItemAddon {
  final String id;
  final String addonId;

  CartItemAddon({
    required this.id,
    required this.addonId
  });

  factory CartItemAddon.fromJson(Map<String, dynamic> json) {
    return CartItemAddon(
      id: json['id'].toString(),
      addonId: json['addon_id'].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : int.parse(id),
      'addon_id': int.parse(addonId)
    };
  }
}