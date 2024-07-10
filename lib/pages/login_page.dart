import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:order_it_2/components/my_button.dart';
import 'package:order_it_2/components/my_textfield.dart';
import 'package:order_it_2/controllers/auth/login_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {

  final void Function() onTap;

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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            // Logo
            FadeInDown(
              duration: const Duration(seconds: 3),
              child: Image.asset(
                'assets/icons/Logo.png',
                width: 600,
                height: 300,
              ),
            ),
            
            // Email
            FadeInRight(
              duration: const Duration(seconds: 2),
              child: MyTextfield(
                controller: emailController, 
                hintText: "Email",
                labelText: "Email",
                obscureText: false
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            // Password
            FadeInLeft(
              duration: const Duration(seconds: 2),
              child: MyTextfield(
                controller: passwordController,
                hintText: "Contraseña",
                labelText: "Contraseña",
                obscureText: true
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // Inicio de sesión
            FadeInUp(
              duration: const Duration(seconds: 2),
              child: MyButton(
                text: "Iniciar Sesión",
                linearGradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade400]
                ),
                onTap: () async {
                  // Esconder el teclado
                  FocusManager.instance.primaryFocus?.unfocus();
                  
                  bool hasConnection = await InternetConnectionChecker().hasConnection;

                  if (hasConnection) {
                    if (context.mounted) {
                      loginController.login(
                        context,
                        emailController.text.toLowerCase(),
                        passwordController.text
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // Ir a Registro
            FadeInUp(
              duration: const Duration(seconds: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No eres miembro?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Regístrate",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}