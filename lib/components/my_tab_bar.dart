import 'package:flutter/material.dart';
import 'package:order_it_2/models/food_category.dart';

class MyTabBar extends StatelessWidget implements PreferredSizeWidget{

  final TabController tabController;
  final List<FoodCategory> categories;

  const MyTabBar({
    super.key,
    required this.tabController,
    required this.categories
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      indicatorColor: Colors.white,
      tabAlignment: TabAlignment.start,
      tabs: categories.map((category) {
        return Tab(
          text: category.name,
        );
      }).toList()
    );
  }
  
  @override
  // Devuelve el tamaño preferido del widget, que es la altura estándar de la barra de herramientas (kToolbarHeight)
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}