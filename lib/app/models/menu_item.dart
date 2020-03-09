import 'package:meta/meta.dart';

import 'discount.dart';
import 'ingredient_options.dart';
import 'menu_category.dart';

class MenuItem {
  final String name;
  final MenuCategory category;
  final String description;
  final List<IngredientOptions> ingredientVariations;
  final double price;
  final List<Discount> discounts;

  MenuItem(this.name, this.category, this.description, this.ingredientVariations, this.price, this.discounts);
}
