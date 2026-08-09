class ProductSize {
  final String name; // Small, Medium, Large
  final String volume; // 8 oz, 12 oz, 16 oz
  final double priceMultiplier;

  const ProductSize({
    required this.name,
    required this.volume,
    this.priceMultiplier = 1.0,
  });
}

class MilkOption {
  final String name; // Whole, Oat, Almond, Soy, Coconut
  final double additionalPrice;

  const MilkOption({
    required this.name,
    this.additionalPrice = 0.0,
  });
}

class Extra {
  final String name; // Extra Shot, Whipped Cream, Caramel Drizzle, Vanilla Syrup
  final double price;

  const Extra({
    required this.name,
    required this.price,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String image;
  final double basePrice;
  final double rating;
  final int reviewsCount;
  final int calories;
  final int caffeine; // in mg
  final bool available;
  final bool isPopular;
  final bool isNew;
  final List<ProductSize> sizes;
  final List<MilkOption> milkOptions;
  final List<Extra> extras;
  final List<String> ingredients;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.image,
    required this.basePrice,
    required this.rating,
    required this.reviewsCount,
    required this.calories,
    required this.caffeine,
    this.available = true,
    this.isPopular = false,
    this.isNew = false,
    this.sizes = const [
      ProductSize(name: 'Small', volume: '8 oz', priceMultiplier: 1.0),
      ProductSize(name: 'Medium', volume: '12 oz', priceMultiplier: 1.25),
      ProductSize(name: 'Large', volume: '16 oz', priceMultiplier: 1.5),
    ],
    this.milkOptions = const [
      MilkOption(name: 'Whole Milk', additionalPrice: 0.0),
      MilkOption(name: 'Oat Milk', additionalPrice: 0.75),
      MilkOption(name: 'Almond Milk', additionalPrice: 0.75),
      MilkOption(name: 'Soy Milk', additionalPrice: 0.50),
    ],
    this.extras = const [
      Extra(name: 'Extra Espresso Shot', price: 1.00),
      Extra(name: 'Whipped Cream', price: 0.50),
      Extra(name: 'Caramel Drizzle', price: 0.50),
      Extra(name: 'Vanilla Syrup', price: 0.50),
    ],
    this.ingredients = const ['Espresso', 'Water'],
  });
}
