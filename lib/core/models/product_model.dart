import 'package:get/get.dart';

class ProductSize {
  final String name; // Small, Medium, Large
  final String? nameAr;
  final String volume; // 8 oz, 12 oz, 16 oz
  final double priceMultiplier;

  const ProductSize({
    required this.name,
    this.nameAr,
    required this.volume,
    this.priceMultiplier = 1.0,
  });

  String get localizedName {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }
}

class MilkOption {
  final String name; // Whole, Oat, Almond, Soy, Coconut
  final String? nameAr;
  final double additionalPrice;

  const MilkOption({
    required this.name,
    this.nameAr,
    this.additionalPrice = 0.0,
  });

  String get localizedName {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }
}

class Extra {
  final String name; // Extra Shot, Whipped Cream, Caramel Drizzle, Vanilla Syrup
  final String? nameAr;
  final double price;

  const Extra({
    required this.name,
    this.nameAr,
    required this.price,
  });

  String get localizedName {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }
}

class Product {
  final String id;
  final String name;
  final String? nameAr;
  final String description;
  final String? descriptionAr;
  final String category;
  final String? categoryAr;
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
  final List<String>? ingredientsAr;

  const Product({
    required this.id,
    required this.name,
    this.nameAr,
    required this.description,
    this.descriptionAr,
    required this.category,
    this.categoryAr,
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
      ProductSize(name: 'Small', nameAr: 'صغير', volume: '8 oz', priceMultiplier: 1.0),
      ProductSize(name: 'Medium', nameAr: 'وسط', volume: '12 oz', priceMultiplier: 1.25),
      ProductSize(name: 'Large', nameAr: 'كبير', volume: '16 oz', priceMultiplier: 1.5),
    ],
    this.milkOptions = const [
      MilkOption(name: 'Whole Milk', nameAr: 'حليب كامل الدسم', additionalPrice: 0.0),
      MilkOption(name: 'Oat Milk', nameAr: 'حليب الشوفان', additionalPrice: 0.75),
      MilkOption(name: 'Almond Milk', nameAr: 'حليب اللوز', additionalPrice: 0.75),
      MilkOption(name: 'Soy Milk', nameAr: 'حليب الصويا', additionalPrice: 0.50),
    ],
    this.extras = const [
      Extra(name: 'Extra Espresso Shot', nameAr: 'جرعة إسبريسو إضافية', price: 1.00),
      Extra(name: 'Whipped Cream', nameAr: 'كريمة مخفوقة', price: 0.50),
      Extra(name: 'Caramel Drizzle', nameAr: 'صوص كراميل', price: 0.50),
      Extra(name: 'Vanilla Syrup', nameAr: 'سيرب فانيليا', price: 0.50),
    ],
    this.ingredients = const ['Espresso', 'Water'],
    this.ingredientsAr,
  });

  String get localizedName {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  String get localizedDescription {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && descriptionAr != null && descriptionAr!.isNotEmpty) {
      return descriptionAr!;
    }
    return description;
  }

  String get localizedCategory {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && categoryAr != null && categoryAr!.isNotEmpty) {
      return categoryAr!;
    }
    return category;
  }

  List<String> get localizedIngredients {
    final code = Get.locale?.languageCode ?? 'en';
    if (code == 'ar' && ingredientsAr != null && ingredientsAr!.isNotEmpty) {
      return ingredientsAr!;
    }
    return ingredients;
  }
}

