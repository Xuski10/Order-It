import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:order_it_2/models/usuario.dart';
import 'package:order_it_2/models/addon.dart';
import 'package:order_it_2/models/cart_food.dart';
import 'package:order_it_2/services/snackbar_helper.dart';
import 'package:order_it_2/utils/random_id.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {

  final supabase = Supabase.instance.client;

  // Singleton
  static final SupabaseApi _instance = SupabaseApi._internal();

  // Factory constructor, devuelve instancias existentes en lugar de crear nuevas
  factory SupabaseApi() {
    return _instance;
  }

  // Private constructor
  SupabaseApi._internal();

  //final supabase = Supabase.instance.client;
  final String baseUrl = 'https://jfpvrylxyunglhbegowh.supabase.co';
  final String apikey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHZyeWx4eXVuZ2xoYmVnb3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjE3MTcsImV4cCI6MjAzNDg5NzcxN30.KujGgYTg_0ZVU5lkujuLZ7EVXloz566IgziKvNwZRf8';
  final String authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHZyeWx4eXVuZ2xoYmVnb3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjE3MTcsImV4cCI6MjAzNDg5NzcxN30.KujGgYTg_0ZVU5lkujuLZ7EVXloz566IgziKvNwZRf8';

  Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
      'apikey': apikey,
      'Authorization': authorization
    };
  }

  Map<String, String> _createHeadersInsert() {
    return {
      'Content-Type': 'application/json',
      'apikey': apikey,
      'Authorization': authorization,
      "Prefer": "return=minimal"
    };
  }

  Future<bool> login(String email, String password, BuildContext context) async {
    
    final url = '$baseUrl/auth/v1/token?grant_type=password';
    final headers = _createHeaders();

    final body = json.encode({
      'email': email,
      'password': password
    });

    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body
    );

    if (response.statusCode != 200) {
      if (context.mounted) {
        SnackbarHelper.showSnackbar(context, 'Usuario o contraseña incorrectos', backgroundColor: Colors.red);
      }
    }

    return response.statusCode == 200;
  }

  Future<bool> register(String email, String password) async {
    final url = '$baseUrl/auth/v1/signup';
    final headers = _createHeaders();

    final body = json.encode({
      'email': email,
      'password': password
    });

    print("Body: $body");

    try{
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
      );

      String peticion = response.body;
      
      print("Response: $peticion");

      if(response.statusCode == 200){
        return true;
      } else {
        if(response.statusCode == 500){
          print('Error del servidor: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      print('Excepción al registrar usuario: $e');
      return false;
    }
  }

  Future<int?> getUserRole(String email) async {
    
    final url = '$baseUrl/rest/v1/users?select=rol&email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if(jsonResponse.isNotEmpty && jsonResponse[0]['rol'] != null) {
        return jsonResponse[0]['rol'];
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener el rol del usuario');
    }
  }

  Future<String?> getUserUUID(String email) async {
    final url = '$baseUrl/rest/v1/users?select=id&email=eq.${Uri.encodeComponent(email)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    if(response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if(jsonResponse.isNotEmpty && jsonResponse[0]['id'] != null){
        return jsonResponse[0]['id'];
      } else {
        return null;
      }
    } else {
      if(kDebugMode){
        print('Error al obtener el UUID del usuario: ${response.statusCode}');
      }
      return null;
    }
  }

  Future<bool> updateUser(updateUser) async {
    try {
      await supabase
          .from("users")
          .update({
            'nombre': updateUser.nombre,
            'apellido_1': updateUser.apellido_1,
            'telefono': updateUser.telefono
          })
          .eq('email', updateUser.email)
          .select();
      
      return true;

    } catch (e) {
      throw 'No se pudieron actualizar los datos';
    }
  }


  Future<void> assignTable(String userId, int tableNumber) async {
    final url = '$baseUrl/rest/v1/tables?id=eq.$tableNumber';
    final headers = _createHeaders();

    final body = jsonEncode({
      'user_id' : userId,
      'table_number' : tableNumber,
      'is_occupied' : true
    });

    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 204) {
      if (kDebugMode) {
        print('Mesa $tableNumber asignada satisfactoriamente');
      }
    } else {
      if (kDebugMode) {
        print('Hubo un error al asignar la mesa $tableNumber: ${response.statusCode} ${response.body}');
      }
    }
  }

  Future<bool> releaseTable(String userId, int tableNumber) async {
    final url = '$baseUrl/rest/v1/tables?table_number=eq.$tableNumber';
    final headers = _createHeaders();

    final body = jsonEncode({
      'user_id' : null,
      'table_number' : tableNumber,
      'is_occupied' : false
    });

    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 204) {
      if (kDebugMode) {
        print('Mesa $tableNumber libre.');
      }
      return true;
    } else {
      if (kDebugMode) {
        print(
          'Hubo un error al desasignar la mesa $tableNumber: ${response.statusCode} ${response.body}',
        );
      }
      return false;
    }
  }

  Future<bool> getIsOccupied(int tableNumber) async {
    final url = '$baseUrl/rest/v1/tables?table_number=eq.$tableNumber';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty && 
          jsonResponse[0]['is_occupied'] != null && 
          jsonResponse[0]['is_occupied']) {
        return true;
      } else {
        return false;
      }
    } else {
      if(kDebugMode){
        print('Error al obtener el UUID del usuario: ${response.statusCode}');
      }
      return false;
    }
  }

  Future<bool> getReservations(String userId) async {
    final url = '$baseUrl/rest/v1/tables?select*&user_id=eq.$userId';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// Obtiene la información de los platos desde la API REST.
///
/// Parámetros:
/// - [foodId]: (Opcional) El ID del plato. Si se proporciona, se obtiene un plato específico;
///   de lo contrario, se obtienen todos los platos.
///
/// Retorna:
/// - Una lista de mapas que contienen la información de los platos.
///
/// Lanza:
/// - Una excepción si ocurre un error durante la obtención de los platos.
Future<List<Map<String, dynamic>>> getFood({String? foodId}) async {
    final headers = _createHeaders();
    String url;

    if (foodId != null) {
        url = '$baseUrl/rest/v1/food?select=*&id=eq.$foodId';
    } else {
        url = '$baseUrl/rest/v1/food?select=*';
    }

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
    } else {
        throw Exception('Error al cargar los platos');
    }
}


  Future<List<Map<String, dynamic>>> getFoodAddons() async {
    final url = '$baseUrl/rest/v1/food_addon?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los complementos');
    }
  }

  Future<List<Map<String, dynamic>>> getAddons() async {
    final url = '$baseUrl/rest/v1/addon?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String,dynamic>>();
    } else {
      throw Exception('Error al cargar los complementos');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final url = '$baseUrl/rest/v1/category?select=*';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }

  Future<List<Map<String, dynamic>>> getOrders([String? userId]) async {
    final supabase = Supabase.instance.client;
    final user = await supabase.auth.getUser();

    userId = userId ?? user.user?.id;

    final url = '$baseUrl/rest/v1/cart?select*&is_finished=eq.true&user_id=eq.$userId';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar el carrito del cliente: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUser([String? email]) async {
    final supabase = Supabase.instance.client;
    final user = await supabase.auth.getUser();

    final url = '$baseUrl/rest/v1/users?email=eq.${Uri.encodeComponent(user.user!.email!)}';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Error al traer el usuario');
    }

    final List<dynamic> jsonResponse = json.decode(response.body);

    if (kDebugMode) {
      print(jsonResponse);
    }

    return jsonResponse.cast<Map<String, dynamic>>();
  }

  // Carrito

  // REVISAR
  /// Obtiene los items del carrito desde la API REST.
  ///
  /// Parámetros:
  /// - [cartId]: El ID del carrito.
  ///
  /// Retorna:
  /// - Una lista de mapas que contienen la información de los items del carrito.
  ///
  /// Lanza:
  /// - Una excepción si ocurre un error durante la obtención de los items.
  Future<List<Map<String, dynamic>>> fetchCartItems(String cartId) async {
      final headers = _createHeaders();

      final url = '$baseUrl/rest/v1/cart_item?select=*&cart_id=eq.$cartId';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = json.decode(response.body);
          return jsonResponse.cast<Map<String, dynamic>>();
      } else {
          throw Exception('Error al cargar los items del carrito desde la API');
      }
  }


  Future<List<Map<String, dynamic>>> getFoodFromCart(foodId) async {
    final url = '$baseUrl/rest/v1/food?select=*&id=eq.$foodId';
    final headers = _createHeaders();

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar los pedidos del carrito');
    }
  }

  Future<List<Addon>> getFoodAddonsFromCart(String cartItemId) async {
    
    // Extraer los pedidos del carrito
    final response = await supabase.from('cart_item_addon').select('*').eq('cart_item_id', cartItemId);

    // Extraer los addon_id de los pedidos del carrito
    List<int> addonIds = 
        response.map<int>((item) => item['addon_id'] as int).toList();
    
    if (addonIds.isEmpty) {
      if (kDebugMode) {
        print('No se encontraron complementos para este plato');
      }
      return [];
    }

    // 
    final conditions = addonIds.map((id) => 'id.eq.$id').join(',');

    // Obtener los addons usando los addon_id de los pedidos del carrito
    final addonDetailsResponse = 
        await supabase.from('addon').select('*').or(conditions);
    
    List<Addon> addonList = addonDetailsResponse
        .map<Addon>((json) => Addon.fromJson(json))
        .toList();
    
    return addonList;
  }

  Future<String> createCart(List<CartFood> cartFood, double total) async {
    final urlCart = '$baseUrl/rest/v1/cart';
    final urlCartItem = '$baseUrl/rest/v1/cart_item';
    final urlCartItemAddon = '$baseUrl/rest/v1/cart_item_addon';
    final headers = _createHeadersInsert();

    // Convertir DateTime.now() a ISO 8601 string
    final now = DateTime.now().toUtc().toIso8601String();
    final cartId = RandomIds.generateRandomId().toString();
    final supabase = Supabase.instance.client;
    final UserResponse userResponse = await supabase.auth.getUser();
  
    print(total.roundToDouble());

    try {
      await http.post(
        Uri.parse(urlCart),
        headers: headers,
        body: jsonEncode({
          "id": cartId,
          "user_id": userResponse.user!.id,
          "price": double.parse(total.toStringAsFixed(2)),
          "is_finished": true,
          "created_at": now
        })
      );

      for(var item in cartFood) {
        await http.post(
          Uri.parse(urlCartItem),
          headers: headers,
          body: jsonEncode({
            "id": item.id,
            "cart_id": cartId,
            "food_id": item.food.id,
            "quantity": item.quantity
          })
        );

        if (item.addons.isNotEmpty) {
          for(var addon in item.addons) {
            await http.post(
              Uri.parse(urlCartItemAddon),
              headers: headers,
              body: jsonEncode({"cart_item_id": item.id, "addon_id": addon.id}),
            );
          }
        }
      }

      return cartId;

    } catch (e) {
      throw Exception('Error al crear el carrito $e');
    }
  }
}