import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_button.dart';
import 'package:order_it_2/components/my_textfield.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/icons/Logo.png',
            width: 500,
            height: 300,
          ),
          // Email
          MyTextfield(
            controller: emailController, 
            hintText: "Email",
            labelText: "Email",
            obscureText: false
          ),
          // Password
          MyTextfield(
            controller: passwordController,
            hintText: "Password",
            labelText: "Password",
            obscureText: true
          ),
          // Inicio de sesión
          MyButton(text: "Iniciar Sesión")
        ],
      ),
    );
  }
}