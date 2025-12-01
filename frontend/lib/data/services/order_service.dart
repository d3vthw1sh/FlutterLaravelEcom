import '../../core/constants.dart';
import '../models/order.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  // Create Order
  Future<Order> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.orders,
        data: data,
      );
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Get My Orders
  Future<List<Order>> getMyOrders() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.myOrders);

      // Handle both array and object responses
      List<dynamic> data;
      if (response.data is List) {
        data = response.data;
      } else if (response.data is Map<String, dynamic>) {
        // If wrapped in an object, try to extract the orders array
        data = response.data['orders'] ?? response.data['data'] ?? [];
      } else {
        data = [];
      }

      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get Order by ID
  Future<Order> getOrderById(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.orders}/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel Order
  Future<void> cancelOrder(String id) async {
    try {
      await _apiService.dio.delete('${ApiConstants.orders}/$id');
    } catch (e) {
      rethrow;
    }
  }
}
