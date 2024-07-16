import 'package:flutter/material.dart';
import 'package:order_it_2/controllers/food_controller.dart';

class HomePage extends StatefulWidget {

  final bool ordersAllowed;

  const HomePage({
    super.key,
    required this.ordersAllowed
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  late TabController _tabController;
  final FoodController _foodController = FoodController();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}