import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_button.dart';
import 'package:order_it_2/components/my_textfield.dart';
import 'package:order_it_2/controllers/auth/register_controller.dart';

class RegisterPage extends StatelessWidget {

  final void Function()? onTap;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RegisterController registerController = RegisterController();

  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/icons/Logo.png',
            width: size.width * 1.2,
            height: size.height * 0.4,
          ),
          
          Text(
            '¡Crea tu cuenta ahora!',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.inversePrimary
            ),
          ),

          const SizedBox( height: 25 ),

          // Email
          MyTextfield(
            controller: emailController,
            hintText: "Email",
            labelText: "Email",
            obscureText: false
          ),

          const SizedBox( height: 20 ),

          // Contraseña
          MyTextfield(
            controller: passwordController,
            hintText: "Contraseña",
            labelText: "Contraseña",
            obscureText: true
          ),

          const SizedBox( height: 20 ),

          // Confirmar contraseña
          MyTextfield(
            controller: confirmPasswordController,
            hintText: "Confirmar contraseña",
            labelText: "Confirmar contraseña",
            obscureText: true
          ),

          const SizedBox( height: 45 ),

          // Registrar
          MyButton(
            text: "Registrar",
            linearGradient: 
              LinearGradient(
                colors: [Colors.green.shade700, Colors.green.shade400]
              ),
            onTap: () {
              // Esconder el teclado
            },
          )
        ],
      ),
    );
  }
}