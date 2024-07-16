import 'package:flutter/material.dart';
import 'package:order_it_2/auth/login_or_register.dart';
import 'package:order_it_2/models/restaurant.dart';
import 'package:order_it_2/pages/first_page.dart';
import 'package:order_it_2/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  await Supabase.initialize(
    url: 'https://jfpvrylxyunglhbegowh.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHZyeWx4eXVuZ2xoYmVnb3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjE3MTcsImV4cCI6MjAzNDg5NzcxN30.KujGgYTg_0ZVU5lkujuLZ7EVXloz566IgziKvNwZRf8'
  );
  runApp(MultiProvider(
    providers: [
      // Provider del tema
      ChangeNotifierProvider(
        create: (context) => ThemeProvider()
      ),
      ChangeNotifierProvider(
        create: (context) => Restaurant(),
      )
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}