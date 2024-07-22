import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/order_controller.dart';
import 'package:order_it_2/models/cart.dart';
import 'package:order_it_2/pages/my_order_details.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final OrderController orderController = OrderController();
  late Future<List<Cart>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = orderController.fetchOrders();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureOrders = orderController.fetchOrders();
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(26.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Todos los pedidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cart>>(
              future: futureOrders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay pedidos disponible'
                    ),
                  );
                } else {
                  final carts = snapshot.data!;
                  return ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => 
                                MyOrderDetails(cart: cart),
                            )
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric( horizontal: 25.0, vertical: 8.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.food_bank),
                            ),
                            title: const Text('Restaurante: Order It!'),
                            subtitle: const Text('Fecha: 22/07/2024'),
                            trailing: Text(
                              '${cart.price} €',
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
          )
        ],
      ),
    );
  }
}