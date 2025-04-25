import 'package:flutter/material.dart';
import '../models/recipe.dart';

class IngredientScreen extends StatelessWidget {
  static const routeName = '/ingredients';
  const IngredientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text('Ingredients', style: theme.textTheme.headlineMedium),
          ),

          // Ingredients List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recipe.ingredients.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final ingredient = recipe.ingredients[i];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      ingredient,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
