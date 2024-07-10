import 'package:order_it_2/models/addon.dart';

class Food {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final String categoryId;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.categoryId
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : int.parse(id),
      'name' : name,
      'description' : description,
      'imagepath' : imagePath,
      'price' : price,
      'category_id' : int.parse(categoryId)
    };
  }
}