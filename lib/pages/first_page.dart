import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:order_it_2/components/my_drawer.dart';
import 'package:order_it_2/controllers/auth/login_controller.dart';
import 'package:order_it_2/pages/assign_table.dart';
import 'package:order_it_2/pages/home_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      drawer: const MyDrawer(ordersAllowed: false),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu)
            );
          }
        ),
        title: const Text('Order It!'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric( horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido a Order It!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox( height: 40 ),

              // Contenedor de "Ver la carta"
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(ordersAllowed: false),
                    )
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 243, 221),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        height: 200,
                        width: 300,
                        "assets/animations/plato_girando.json"
                      ),
                      const Text(
                        'Ver la carta',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                      ),
                      const SizedBox( height: 15 )
                    ],
                  ),
                ),
              ),

              const SizedBox( height: 25 ),

              // Container de "Pedir Online"
              GestureDetector(
                onTap: () async {
                  String userId = await LoginController().getUserID();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignTable(userId: "asd"),
                      )
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric( vertical: 10 ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 243, 221),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        height: 200,
                        width: 300,
                        "assets/animations/mobile_scrolling.json"
                      ),
                      const Text(
                        'Pedir Online',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox( height: 15 )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}