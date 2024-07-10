import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  final String id;
  final String nombre;

  Category({
    required this.id,
    required this.nombre,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"].toString(),
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}