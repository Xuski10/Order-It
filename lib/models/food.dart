import 'package:order_it_2/models/addon.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String categoryId;
  final List<String> addonIds;
  List<Addon>? addons;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.categoryId,
    required this.addonIds,
    this.addons,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      imagePath: json['imagepath'],
      price: json['price'].toDouble(),
      categoryId: json['category_id'].toString(),
      addonIds: json.containsKey('addon_ids')
          ? List<String>.from(
              json['addon_ids'].map((addonId) => addonId.toString()))
          : [],
      addons: json['addons'] != null
          ? List<Addon>.from(
              json['addons'].map((addon) => Addon.fromJson(addon)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'name': name,
      'description': description,
      'imagepath': imagePath,
      'price': price,
      'category_id': int.parse(categoryId),
      'addon_ids': addonIds.map(int.parse).toList(),
      'addons': addons?.map((addon) => addon.toJson()).toList(),
    };
  }
}
