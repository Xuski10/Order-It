import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/auth/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = LoginController();

  final supabase = Supabase.instance.client;
  
  @override
  Widget build(BuildContext context) {
    return const Text('Login');
  }
}