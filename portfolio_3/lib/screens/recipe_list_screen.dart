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
      appBar: AppBar(title: Text('$displayCategory Recipes')),
      body: FutureBuilder<List<Recipe>>(
        future: Recipe.loadAll(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
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
              return ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (ctx, i) {
                  final recipe = recipes[i];
                  return ListTile(
                    title: Text(recipe.name),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        IngredientScreen.routeName,
                        arguments: recipe,
                      );
                    },
                  );
                },
              );
            case ConnectionState.none:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
        },
      ),
    );
  }
}
