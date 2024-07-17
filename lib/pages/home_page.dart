import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_drawer.dart';
import 'package:order_it_2/controllers/food_category_controller.dart';
import 'package:order_it_2/controllers/food_controller.dart';
import 'package:order_it_2/models/food.dart';
import 'package:order_it_2/models/food_category.dart';

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para deshabilitar volver atrás
        return false;
      },
      child: FutureBuilder<List<FoodCategory>>(
        future: FoodCategoryController().fetchCategories(),
        builder: (context, categorySnapshot) {
          if (categorySnapshot.connectionState == ConnectionState.waiting) {
            return const Center( child: CircularProgressIndicator() );
          } else if (categorySnapshot.hasError) {
            return Center( child: Text('Error: ${categorySnapshot.error}') );
          } else {
            final categories = categorySnapshot.data ?? [];
            _tabController = TabController(length: categories.length, vsync: this);

            return FutureBuilder<List<Food>>(
              future: _foodController.fetchAllFood(),
              builder: (context, foodSnapshot) {
                if (foodSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center( child: CircularProgressIndicator());
                } else if (foodSnapshot.hasError) {
                  return Center( child: Text('Error: ${foodSnapshot.error}'));
                } else {
                  final foods = foodSnapshot.data ?? [];
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    drawer: MyDrawer(ordersAllowed: widget.ordersAllowed),
                    appBar: AppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      leading: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                      title: const Text('Order It!'),
                    ),
                  );
                }
              },
            )
          }
        },
      ),
    );
  }
}