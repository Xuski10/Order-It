import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {

  final supabase = Supabase.instance.client;
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
        // todo: SnackBarHelper
      }
    }
  }
}