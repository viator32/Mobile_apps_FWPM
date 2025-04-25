import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Recipe {
  final String name;
  final String category;
  final List<String> ingredients;

  Recipe({
    required this.name,
    required this.category,
    required this.ingredients,
  });

  factory Recipe.fromMap(Map<String, dynamic> m) {
    return Recipe(
      name: m['name'] as String,
      category: m['category'] as String,
      ingredients: List<String>.from(m['ingredients'] as List<dynamic>),
    );
  }

  /// Load all recipes from assets/recipes.json.
  static Future<List<Recipe>> loadAll() async {
    final data = await rootBundle.loadString('assets/recipes.json');
    final map = json.decode(data) as Map<String, dynamic>;
    final raws = map['recipes'] as List<dynamic>;
    return raws.map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();
  }

  /// asynchronously load and return all unique categories.
  static Future<List<String>> loadCategories() async {
    final all = await loadAll();
    final cats = all.map((r) => r.category).toSet().toList();
    cats.sort();
    return cats;
  }

  /// gives an existing list of recipes, return unique categories
  static List<String> categoriesFrom(List<Recipe> recipes) {
    final cats = recipes.map((r) => r.category).toSet().toList();
    cats.sort();
    return cats;
  }
}
