/// API endpoints for the application
class ApiEndpoints {
  static const String baseUrl = '/api/v1';

  // Authentication endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String resendVerification = '$baseUrl/auth/resend-verification';

  // User endpoints
  static const String profile = '$baseUrl/user/profile';
  static const String updateProfile = '$baseUrl/user/profile';
  static const String changePassword = '$baseUrl/user/change-password';
  static const String deleteAccount = '$baseUrl/user/delete-account';

  // Product endpoints
  static const String products = '$baseUrl/products';
  static String productById(int id) => '$baseUrl/products/$id';
  static const String categories = '$baseUrl/categories';
  static String categoryProducts(int categoryId) =>
      '$baseUrl/categories/$categoryId/products';
  static const String brands = '$baseUrl/brands';
  static String brandProducts(String brandSlug) =>
      '$baseUrl/brands/$brandSlug/products';
  static const String searchProducts = '$baseUrl/products/search';
  static const String featuredProducts = '$baseUrl/products/featured';
  static const String popularProducts = '$baseUrl/products/popular';

  // Cart endpoints
  static const String cart = '$baseUrl/cart';
  static const String addToCart = '$baseUrl/cart/add';
  static String updateCartItem(int itemId) => '$baseUrl/cart/items/$itemId';
  static String removeCartItem(int itemId) => '$baseUrl/cart/items/$itemId';
  static const String clearCart = '$baseUrl/cart/clear';

  // Order endpoints
  static const String orders = '$baseUrl/orders';
  static const String createOrder = '$baseUrl/orders';
  static String orderById(int id) => '$baseUrl/orders/$id';
  static String cancelOrder(int id) => '$baseUrl/orders/$id/cancel';
  static String trackOrder(String orderNumber) =>
      '$baseUrl/orders/track/$orderNumber';

  // Wishlist endpoints
  static const String wishlist = '$baseUrl/wishlist';
  static const String addToWishlist = '$baseUrl/wishlist/add';
  static String removeFromWishlist(int productId) =>
      '$baseUrl/wishlist/remove/$productId';

  // Review endpoints
  static String productReviews(int productId) =>
      '$baseUrl/products/$productId/reviews';
  static String addProductReview(int productId) =>
      '$baseUrl/products/$productId/reviews';
  static String updateReview(int reviewId) => '$baseUrl/reviews/$reviewId';
  static String deleteReview(int reviewId) => '$baseUrl/reviews/$reviewId';

  // Address endpoints
  static const String addresses = '$baseUrl/addresses';
  static const String addAddress = '$baseUrl/addresses';
  static String updateAddress(int id) => '$baseUrl/addresses/$id';
  static String deleteAddress(int id) => '$baseUrl/addresses/$id';
  static String setDefaultAddress(int id) => '$baseUrl/addresses/$id/default';

  // Notification endpoints
  static const String notifications = '$baseUrl/notifications';
  static String markNotificationRead(int id) =>
      '$baseUrl/notifications/$id/read';
  static const String markAllNotificationsRead =
      '$baseUrl/notifications/mark-all-read';

  // Support endpoints
  static const String contactUs = '$baseUrl/contact';
  static const String faq = '$baseUrl/faq';
  static const String supportTickets = '$baseUrl/support/tickets';
  static const String createSupportTicket = '$baseUrl/support/tickets';
}
