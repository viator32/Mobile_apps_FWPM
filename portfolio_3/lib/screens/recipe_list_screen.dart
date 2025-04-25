import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'ingredient_screen.dart';

class RecipeListScreen extends StatelessWidget {
  static const routeName = '/recipes';
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryArg = ModalRoute.of(context)!.settings.arguments as String;
    final displayCategory =
        categoryArg[0].toUpperCase() + categoryArg.substring(1);

    return Scaffold(
      appBar: AppBar(
        title: Text('$displayCategory Recipes'),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: Recipe.loadAll(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allRecipes = snapshot.data ?? [];
          final recipes =
              allRecipes
                  .where((r) => r.category == categoryArg)
                  .take(3)
                  .toList();

          if (recipes.isEmpty) {
            return Center(child: Text('No recipes for $displayCategory.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            separatorBuilder:
                (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                  indent: 16,
                  endIndent: 16,
                ),
            itemCount: recipes.length,
            itemBuilder: (ctx, i) {
              final recipe = recipes[i];
              final ingredientCount = recipe.ingredients.length;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        IngredientScreen.routeName,
                        arguments: recipe,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Text block
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$ingredientCount ingredient${ingredientCount == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Chevron
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey.shade400,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
