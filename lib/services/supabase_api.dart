import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_it_2/services/snackbar_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {

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
        SnackbarHelper.showSnackbar(
          context,
          "Inicio de sesión incorrecto",
          backgroundColor: Colors.red
        );
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
}