import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  // Auth
  static const String login = '/api/users/login';
  static const String register = '/api/users/register';
  static const String profile = '/api/users/profile';
  static const String forgotPassword = '/api/users/forgot-password';
  static const String resetPassword =
      '/api/users/reset-password'; // Append /:token
  static const String verifyEmail = '/api/users/verify'; // Append /:token

  // Products
  static const String products = '/api/products';
  static const String productReviews = '/reviews'; // Used as suffix

  // Orders
  static const String orders = '/api/orders';
  static const String myOrders = '/api/orders/my-orders';

  // Stripe
  static const String createCheckoutSession =
      '/api/stripe/create-checkout-session';

  static String resolveImageUrl(String path) {
    // If it's already an asset path, return as-is
    if (path.startsWith('assets/')) {
      return path;
    }

    // If the path is already a full URL, adjust localhost for Android emulator if needed
    if (path.startsWith('http')) {
      if (Platform.isAndroid && path.contains('localhost')) {
        return path.replaceAll('localhost', '10.0.2.2');
      }
      return path;
    }

    // Map backend image paths to local assets
    // Extract filename from path (handle both /uploads/filename and just filename)
    String filename = path;
    if (path.contains('/')) {
      filename = path.split('/').last;
    }

    // Check if this is a product image and map to local asset
    if (filename.isNotEmpty) {
      // Try to find matching local asset
      final localAssetPath = 'assets/images/products/$filename';
      return localAssetPath;
    }

    // Fallback: return original path pointing to server
    String normalizedPath = path;
    if (!path.startsWith('/') && !path.startsWith('uploads/')) {
      normalizedPath = '/uploads/$path';
    } else if (!path.startsWith('/uploads/')) {
      normalizedPath = '/uploads/${path.replaceFirst('/', '')}';
    }
    return '$baseUrl$normalizedPath';
  }
}
