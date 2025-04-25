import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_list_screen.dart';
import 'screens/ingredient_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Portfolio Exam',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (c) => const HomeScreen(),
        RecipeListScreen.routeName: (c) => const RecipeListScreen(),
        IngredientScreen.routeName: (c) => const IngredientScreen(),
      },
    );
  }
}
