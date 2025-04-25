import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_list_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Cuisine')),
      body: FutureBuilder<List<String>>(
        future: Recipe.loadCategories(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final categories = snapshot.data ?? [];
              if (categories.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (ctx, i) {
                  final category = categories[i];
                  final display =
                      category[0].toUpperCase() + category.substring(1);
                  return ListTile(
                    title: Text(display),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RecipeListScreen.routeName,
                        arguments: category,
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
