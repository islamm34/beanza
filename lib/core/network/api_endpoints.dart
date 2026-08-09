class ApiEndpoints {
  static const String baseUrl = 'https://api.caffeinelive.com';

  // Products
  static const String products = '/products';
  static const String productDetails = '/products';
  static const String searchProducts = '/products/search';

  // Cafes
  static const String cafes = '/cafes';
  static const String cafeDetails = '/cafes';
  static const String nearbyCafes = '/cafes/nearby';

  // Orders
  static const String orders = '/orders';
  static const String orderDetails = '/orders';
  static const String orderTracking = '/orders/track';
  static const String cancelOrder = '/orders/cancel';

  // Authentication
  static const String login = '/auth/login';
  static const String signup = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String verifyEmail = '/auth/verify-email';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User Profile
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String preferences = '/users/preferences';

  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/items';
  static const String removeFromCart = '/cart/items';
  static const String updateCart = '/cart/items';
  static const String clearCart = '/cart/clear';

  // Checkout
  static const String checkout = '/checkout';
  static const String paymentMethods = '/payment-methods';

  // Rewards & Points
  static const String rewards = '/rewards';
  static const String rewardsHistory = '/rewards/history';
  static const String redeemRewards = '/rewards/redeem';
  static const String loyaltyTiers = '/loyalty/tiers';

  // Wallet
  static const String wallet = '/wallet';
  static const String walletTopup = '/wallet/topup';
  static const String walletTransactions = '/wallet/transactions';

  // Favorites
  static const String favorites = '/favorites';
  static const String addFavorite = '/favorites';
  static const String removeFavorite = '/favorites';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsSettings = '/notifications/settings';

  // QR & Barcode
  static const String scanQR = '/scan/qr';
  static const String scanBarcode = '/scan/barcode';
  static const String qrGenerate = '/qr/generate';

  // Settings
  static const String supportTickets = '/support/tickets';
  static const String createTicket = '/support/tickets';
  static const String faq = '/faq';
}
