import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/order_controller.dart';
import 'package:order_it_2/models/cart.dart';

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
      ),
    );
  }
}