import 'package:get/get.dart';
import '../models/product_model.dart';

class LocalProductCatalog {
  static const List<Product> products = [
    // Hot Coffee
    Product(
      id: 'prod_1',
      name: 'Espresso',
      nameAr: 'إسبريسو',
      description: 'Pure, concentrated coffee served in small, strong shots.',
      descriptionAr: 'قهوة نقية ومركزة تُقدم في جرعة غنية وقوية.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/espresso.jpg',
      basePrice: 3.50,
      rating: 4.8,
      reviewsCount: 142,
      calories: 5,
      caffeine: 63,
      isPopular: true,
      ingredients: ['Espresso Shot'],
      ingredientsAr: ['جرعة إسبريسو'],
    ),
    Product(
      id: 'prod_2',
      name: 'Double Espresso',
      nameAr: 'دبل إسبريسو',
      description:
          'Two shots of rich, dark-roast espresso for double the bold flavor.',
      descriptionAr: 'جرعتان من الإسبريسو المركز لنكهة مضاعفة وجريئة.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/double_espresso.jpg',
      basePrice: 4.25,
      rating: 4.9,
      reviewsCount: 98,
      calories: 10,
      caffeine: 126,
      ingredients: ['Double Espresso Shot'],
      ingredientsAr: ['جرعة دبل إسبريسو'],
    ),
    Product(
      id: 'prod_3',
      name: 'Americano',
      nameAr: 'أمريكانو',
      description:
          'Espresso shots topped with hot water create a light layer of crema.',
      descriptionAr: 'جرعات إسبريسو مع ماء ساخن مع طبقة كريما خفيفة.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/americano.jpg',
      basePrice: 4.00,
      rating: 4.7,
      reviewsCount: 210,
      calories: 15,
      caffeine: 150,
      ingredients: ['Espresso', 'Hot Water'],
      ingredientsAr: ['إسبريسو', 'ماء ساخن'],
    ),
    Product(
      id: 'prod_4',
      name: 'Cappuccino',
      nameAr: 'كابتشينو',
      description:
          'Dark, rich espresso under a smoothed and stretched layer of thick foam.',
      descriptionAr: 'إسبريسو غني تحت طبقة ناعمة من رغوة الحليب الكثيفة.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/cappuccino.jpg',
      basePrice: 5.25,
      rating: 4.9,
      reviewsCount: 350,
      calories: 140,
      caffeine: 150,
      isPopular: true,
      ingredients: ['Espresso', 'Steamed Milk', 'Foam'],
      ingredientsAr: ['إسبريسو', 'حليب مبخر', 'رغوة'],
    ),
    Product(
      id: 'prod_5',
      name: 'Caffè Latte',
      nameAr: 'كافيه لاتيه',
      description:
          'Rich, full-bodied espresso in steamed milk with a light layer of foam.',
      descriptionAr: 'إسبريسو كامل القوام مع حليب مبخر وطبقة رغوة خفيفة.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/latte.jpg',
      basePrice: 5.50,
      rating: 4.8,
      reviewsCount: 412,
      calories: 190,
      caffeine: 150,
      isPopular: true,
      ingredients: ['Espresso', 'Steamed Milk'],
      ingredientsAr: ['إسبريسو', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_6',
      name: 'Flat White',
      nameAr: 'فلات وايت',
      description:
          'Smooth ristretto shots of espresso with sweet steamed milk.',
      descriptionAr: 'جرعات ريستريتو ناعمة من الإسبريسو مع حليب مبخر مخملي.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/flat_white.jpg',
      basePrice: 5.00,
      rating: 4.8,
      reviewsCount: 180,
      calories: 120,
      caffeine: 130,
      ingredients: ['Ristretto Espresso', 'Steamed Whole Milk'],
      ingredientsAr: ['ريستريتو إسبريسو', 'حليب مبخر كامل الدسم'],
    ),
    Product(
      id: 'prod_7',
      name: 'Cortado',
      nameAr: 'كورتادو',
      description:
          'Equal parts double espresso and warm steamed milk to reduce acidity.',
      descriptionAr: 'نسب متساوية من الدبل إسبريسو والحليب المبخر الدافئ.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/cortado.jpg',
      basePrice: 4.75,
      rating: 4.7,
      reviewsCount: 88,
      calories: 80,
      caffeine: 130,
      ingredients: ['Double Espresso', 'Steamed Milk'],
      ingredientsAr: ['دبل إسبريسو', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_8',
      name: 'Macchiato',
      nameAr: 'ماكياتو',
      description:
          'Espresso marked with a small dollop of velvety steamed milk foam.',
      descriptionAr: 'إسبريسو مميز بلمسة من رغوة الحليب المخملية.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/macchiato.jpg',
      basePrice: 4.50,
      rating: 4.6,
      reviewsCount: 75,
      calories: 25,
      caffeine: 150,
      ingredients: ['Espresso', 'Milk Foam'],
      ingredientsAr: ['إسبريسو', 'رغوة حليب'],
    ),
    Product(
      id: 'prod_9',
      name: 'Mocha',
      nameAr: 'موكا',
      description: 'Rich espresso, bittersweet mocha sauce and steamed milk.',
      descriptionAr: 'إسبريسو غني مع صوص شوكولاتة الموكا وحليب مبخر.',
      category: 'Hot Coffee',
      categoryAr: 'قهوة ساخنة',
      image: 'assets/images/coffee/mocha.jpg',
      basePrice: 5.75,
      rating: 4.9,
      reviewsCount: 290,
      calories: 290,
      caffeine: 175,
      isPopular: true,
      ingredients: ['Espresso', 'Mocha Sauce', 'Steamed Milk', 'Whipped Cream'],
      ingredientsAr: ['إسبريسو', 'صوص موكا', 'حليب مبخر', 'كريمة مخفوقة'],
    ),

    // Iced Coffee
    Product(
      id: 'prod_10',
      name: 'Iced Americano',
      nameAr: 'آيس أمريكانو',
      description: 'Espresso shots topped with cold water and served over ice.',
      descriptionAr: 'جرعات إسبريسو ممتزجة مع ماء بارد ومقدمة مع الثلج.',
      category: 'Iced Coffee',
      categoryAr: 'قهوة باردة',
      image: 'assets/images/coffee/iced_americano.jpg',
      basePrice: 4.25,
      rating: 4.7,
      reviewsCount: 195,
      calories: 15,
      caffeine: 150,
      ingredients: ['Espresso', 'Cold Water', 'Ice'],
      ingredientsAr: ['إسبريسو', 'ماء بارد', 'ثلج'],
    ),
    Product(
      id: 'prod_11',
      name: 'Iced Latte',
      nameAr: 'آيس لاتيه',
      description:
          'Full-bodied espresso combined with milk and poured over ice.',
      descriptionAr: 'إسبريسو مركز ممزوج مع الحليب البارد ومسكوب فوق الثلج.',
      category: 'Iced Coffee',
      categoryAr: 'قهوة باردة',
      image: 'assets/images/coffee/iced_latte.jpg',
      basePrice: 5.75,
      rating: 4.8,
      reviewsCount: 320,
      calories: 130,
      caffeine: 150,
      isPopular: true,
      ingredients: ['Espresso', 'Milk', 'Ice'],
      ingredientsAr: ['إسبريسو', 'حليب', 'ثلج'],
    ),
    Product(
      id: 'prod_12',
      name: 'Iced Mocha',
      nameAr: 'آيس موكا',
      description:
          'Espresso combined with bittersweet mocha sauce, milk and ice.',
      descriptionAr: 'إسبريسو مع صوص الشوكولاتة اللذيذ والحليب المنعش والثلج.',
      category: 'Iced Coffee',
      categoryAr: 'قهوة باردة',
      image: 'assets/images/coffee/iced_mocha.jpg',
      basePrice: 6.00,
      rating: 4.9,
      reviewsCount: 240,
      calories: 280,
      caffeine: 175,
      ingredients: ['Espresso', 'Mocha Sauce', 'Milk', 'Ice'],
      ingredientsAr: ['إسبريسو', 'صوص موكا', 'حليب', 'ثلج'],
    ),
    Product(
      id: 'prod_13',
      name: 'Cold Brew',
      nameAr: 'كولد برو',
      description:
          'Slow-steeped in cool water for 20 hours for an ultra-smooth finish.',
      descriptionAr: 'منقوع ببطء في ماء بارد لمدة 20 ساعة لنقاء وسلاسة فائقة.',
      category: 'Iced Coffee',
      categoryAr: 'قهوة باردة',
      image: 'assets/images/coffee/cold_brew.jpg',
      basePrice: 5.25,
      rating: 4.9,
      reviewsCount: 510,
      calories: 5,
      caffeine: 205,
      isPopular: true,
      isNew: true,
      ingredients: ['Cold Brew Coffee', 'Ice'],
      ingredientsAr: ['قهوة كولد برو مقطرة', 'ثلج'],
    ),
    Product(
      id: 'prod_14',
      name: 'Iced Macchiato',
      nameAr: 'آيس ماكياتو',
      description:
          'Espresso poured over iced milk and finished with caramel drizzle.',
      descriptionAr: 'إسبريسو مسكوب فوق حليب مثلج مع لمسة صوص كراميل.',
      category: 'Iced Coffee',
      categoryAr: 'قهوة باردة',
      image: 'assets/images/coffee/iced_macchiato.jpg',
      basePrice: 6.25,
      rating: 4.8,
      reviewsCount: 160,
      calories: 230,
      caffeine: 150,
      ingredients: ['Espresso', 'Milk', 'Caramel Drizzle', 'Ice'],
      ingredientsAr: ['إسبريسو', 'حليب', 'صوص كراميل', 'ثلج'],
    ),

    // Specialty Coffee
    Product(
      id: 'prod_15',
      name: 'Caramel Latte',
      nameAr: 'كراميل لاتيه',
      description: 'Espresso, steamed milk, and sweet buttery caramel syrup.',
      descriptionAr: 'إسبريسو مع حليب مبخر وسيرب كراميل زبدي حلو المذاق.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/caramel_latte.jpg',
      basePrice: 6.25,
      rating: 4.9,
      reviewsCount: 380,
      calories: 250,
      caffeine: 150,
      isPopular: true,
      ingredients: [
        'Espresso',
        'Caramel Syrup',
        'Steamed Milk',
        'Caramel Drizzle'
      ],
      ingredientsAr: ['إسبريسو', 'سيرب كراميل', 'حليب مبخر', 'صوص كراميل'],
    ),
    Product(
      id: 'prod_16',
      name: 'Vanilla Latte',
      nameAr: 'فانيليا لاتيه',
      description:
          'Signature espresso blended with creamy milk and rich vanilla.',
      descriptionAr: 'إسبريسو مميز ممزوج مع حليب كريمي وفانيليا غنية.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/vanilla_latte.jpg',
      basePrice: 6.00,
      rating: 4.8,
      reviewsCount: 260,
      calories: 230,
      caffeine: 150,
      ingredients: ['Espresso', 'Vanilla Syrup', 'Steamed Milk'],
      ingredientsAr: ['إسبريسو', 'سيرب فانيليا', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_17',
      name: 'Spanish Latte',
      nameAr: 'سبانش لاتيه',
      description:
          'Espresso mixed with textured condensed milk for sweet richness.',
      descriptionAr: 'إسبريسو ممزوج مع حليب مكثف محلى لمذاق غني وحلو.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/spanish_latte.jpg',
      basePrice: 6.50,
      rating: 5.0,
      reviewsCount: 490,
      calories: 310,
      caffeine: 150,
      isPopular: true,
      isNew: true,
      ingredients: ['Espresso', 'Sweet Condensed Milk', 'Steamed Milk'],
      ingredientsAr: ['إسبريسو', 'حليب مكثف محلى', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_18',
      name: 'Pistachio Latte',
      nameAr: 'بيستاشيو لاتيه',
      description:
          'Espresso combined with sweet pistachio sauce and steamed milk.',
      descriptionAr: 'إسبريسو ممزوج مع صوص الفستق اللذيذ وحليب مبخر.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/pistachio_latte.jpg',
      basePrice: 6.75,
      rating: 4.9,
      reviewsCount: 215,
      calories: 320,
      caffeine: 150,
      isNew: true,
      ingredients: ['Espresso', 'Pistachio Sauce', 'Steamed Milk'],
      ingredientsAr: ['إسبريسو', 'صوص فستق', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_19',
      name: 'Hazelnut Mocha',
      nameAr: 'بندق موكا',
      description:
          'Espresso with rich chocolate sauce, hazelnut syrup and milk.',
      descriptionAr: 'إسبريسو مع صوص شوكولاتة غني وسيرب بندق وحليب.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/hazelnut_mocha.jpg',
      basePrice: 6.50,
      rating: 4.8,
      reviewsCount: 175,
      calories: 340,
      caffeine: 175,
      ingredients: [
        'Espresso',
        'Chocolate Sauce',
        'Hazelnut Syrup',
        'Steamed Milk'
      ],
      ingredientsAr: ['إسبريسو', 'صوص شوكولاتة', 'سيرب بندق', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_20',
      name: 'Salted Caramel Macchiato',
      nameAr: 'سولتد كراميل ماكياتو',
      description:
          'Espresso with vanilla syrup, steamed milk, and salted caramel.',
      descriptionAr: 'إسبريسو مع سيرب فانيليا وحليب مبخر وصوص كراميل مملح.',
      category: 'Specialty',
      categoryAr: 'مشروبات مميزة',
      image: 'assets/images/coffee/salted_caramel.jpg',
      basePrice: 6.50,
      rating: 4.9,
      reviewsCount: 310,
      calories: 270,
      caffeine: 150,
      isPopular: true,
      ingredients: [
        'Espresso',
        'Vanilla Syrup',
        'Steamed Milk',
        'Salted Caramel'
      ],
      ingredientsAr: ['إسبريسو', 'سيرب فانيليا', 'حليب مبخر', 'كراميل مملح'],
    ),

    // Non-Coffee
    Product(
      id: 'prod_21',
      name: 'Matcha Latte',
      nameAr: 'ماتشا لاتيه',
      description:
          'Smooth Japanese ceremonial green tea matcha whisked with steamed milk.',
      descriptionAr: 'شاي ماتشا ياباني أخضر فاخر مخفوق مع حليب مبخر ناعم.',
      category: 'Non-Coffee',
      categoryAr: 'بدون قهوة',
      image: 'assets/images/coffee/matcha_latte.jpg',
      basePrice: 5.75,
      rating: 4.8,
      reviewsCount: 280,
      calories: 190,
      caffeine: 70,
      isPopular: true,
      ingredients: ['Ceremonial Matcha', 'Steamed Milk'],
      ingredientsAr: ['ماتشا يابانية', 'حليب مبخر'],
    ),
    Product(
      id: 'prod_22',
      name: 'Hot Chocolate',
      nameAr: 'هوت تشوكليت',
      description:
          'Steamed milk with dark chocolate mocha sauce and whipped cream.',
      descriptionAr: 'حليب مبخر مع صوص الشوكولاتة الداكنة وكريمة مخفوقة.',
      category: 'Non-Coffee',
      categoryAr: 'بدون قهوة',
      image: 'assets/images/coffee/hot_chocolate.jpg',
      basePrice: 4.75,
      rating: 4.9,
      reviewsCount: 310,
      calories: 370,
      caffeine: 15,
      ingredients: ['Chocolate Sauce', 'Steamed Milk', 'Whipped Cream'],
      ingredientsAr: ['صوص شوكولاتة داكنة', 'حليب مبخر', 'كريمة مخفوقة'],
    ),
    Product(
      id: 'prod_23',
      name: 'Chai Latte',
      nameAr: 'تشاي لاتيه',
      description:
          'Black tea infused with cinnamon, clove, and warm spices in milk.',
      descriptionAr: 'شاي أسود منقوع بالقرفة والقرنفل وتوابل شاي كرك دافئة في الحليب.',
      category: 'Non-Coffee',
      categoryAr: 'بدون قهوة',
      image: 'assets/images/coffee/chai_latte.jpg',
      basePrice: 5.25,
      rating: 4.7,
      reviewsCount: 190,
      calories: 240,
      caffeine: 50,
      ingredients: ['Spiced Chai Concentrate', 'Steamed Milk'],
      ingredientsAr: ['شاي مبهر مركز', 'حليب مبخر'],
    ),
  ];

  static List<String> get categories => [
        'All',
        'Hot Coffee',
        'Iced Coffee',
        'Specialty',
        'Non-Coffee',
        'Espresso',
        'Latte',
        'Cappuccino',
        'Americano',
      ];

  static String getCategoryDisplayName(String category) {
    final code = Get.locale?.languageCode ?? 'en';
    if (code != 'ar') return category;

    switch (category.toLowerCase()) {
      case 'all':
        return 'الكل';
      case 'hot coffee':
        return 'قهوة ساخنة';
      case 'iced coffee':
        return 'قهوة باردة';
      case 'specialty':
        return 'مشروبات مميزة';
      case 'non-coffee':
        return 'بدون قهوة';
      case 'espresso':
        return 'إسبريسو';
      case 'latte':
        return 'لاتيه';
      case 'cappuccino':
        return 'كابتشينو';
      case 'americano':
        return 'أمريكانو';
      case 'desserts':
        return 'حلويات';
      case 'bakery':
        return 'مخبوزات';
      case 'tea':
        return 'شاي';
      default:
        return category;
    }
  }
}
