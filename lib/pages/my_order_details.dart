import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/order_controller.dart';
import 'package:order_it_2/models/cart.dart';

class MyOrderDetails extends StatefulWidget {
  
  final Cart cart;

  const MyOrderDetails({
    super.key,
    required this.cart
  });

  @override
  State<MyOrderDetails> createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  final OrderController orderController = OrderController();
  late Future<List<Map<String, dynamic>>> futureCartFood;

  @override
  void initState() {
    super.initState();
    futureCartFood = orderController.fetchCartFoodDetails(widget.cart.id);
  }
  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Resumen de tu pedido',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                      ),
                      Text(
                        '${cart.price}€',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                      )
                    ],
                  ),
                  const SizedBox( height: 8 ),
                  const Divider(
                    indent: 50,
                    endIndent: 50,
                    height: 32,
                    thickness: 2,
                    color: Colors.green
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: futureBuild(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

    FutureBuilder<List<Map<String, dynamic>>> futureBuild() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureCartFood,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay pedidos disponibles.'));
        } else {
          final foods = snapshot.data!;
          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                foods[index]['imagepath'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    foods[index]['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (foods[index]["addons"] != null)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: (foods[index]['addons'] as List)
                                .map((addon) => Chip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            addon['name'],
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          Text(
                                              " (${addon['price'].toString()})€",
                                              style: const TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                      backgroundColor: Colors.white,
                                      shape: StadiumBorder(
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}