import 'package:flutter/material.dart';
import '../models/recipe.dart';

class IngredientScreen extends StatelessWidget {
  static const routeName = '/ingredients';
  const IngredientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          recipe.ingredients.join('\n'),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
