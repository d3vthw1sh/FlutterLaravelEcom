import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/product_service.dart';
import '../../../data/models/user.dart';
import '../../../data/models/order.dart';
import '../../../core/constants.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final ApiService _apiService;
  final ProductService _productService;

  AdminBloc({
    required ApiService apiService,
    required ProductService productService,
  }) : _apiService = apiService,
       _productService = productService,
       super(AdminLoading()) {
    on<LoadAllUsers>(_onLoadAllUsers);
    on<LoadAllOrders>(_onLoadAllOrders);
    on<LoadAllProducts>(_onLoadAllProducts);
    on<LoadAllReviews>(_onLoadAllReviews);
    on<DeleteUser>(_onDeleteUser);
    on<DeleteOrder>(_onDeleteOrder);
    on<DeleteProduct>(_onDeleteProduct);
    on<DeleteReview>(_onDeleteReview);
    on<MarkDelivered>(_onMarkDelivered);
    on<UpdateProduct>(_onUpdateProduct);
    on<AddProduct>(_onAddProduct);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsers event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      // Assuming there's an admin endpoint for users
      final response = await _apiService.dio.get('/api/users');

      // Handle wrapped response: { users: [...] }
      List<dynamic> data;
      if (response.data is Map && response.data['users'] != null) {
        data = response.data['users'] as List<dynamic>;
      } else if (response.data is List) {
        data = response.data as List<dynamic>;
      } else {
        throw Exception('Invalid users response format');
      }

      final users = data.map((json) => User.fromJson(json)).toList();
      emit(AdminUsersLoaded(users));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadAllOrders(
    LoadAllOrders event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final response = await _apiService.dio.get(ApiConstants.orders);

      // Handle wrapped response: { orders: [...] } or direct array
      List<dynamic> data;
      if (response.data is Map && response.data['orders'] != null) {
        data = response.data['orders'] as List<dynamic>;
      } else if (response.data is List) {
        data = response.data as List<dynamic>;
      } else {
        throw Exception('Invalid orders response format');
      }

      final orders = data.map((json) => Order.fromJson(json)).toList();
      emit(AdminOrdersLoaded(orders));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadAllProducts(
    LoadAllProducts event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final products = await _productService.getProducts();
      emit(AdminProductsLoaded(products));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _apiService.dio.delete('/api/users/${event.id}');
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _apiService.dio.delete('${ApiConstants.orders}/${event.id}');
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _productService.deleteProduct(event.id);
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onMarkDelivered(
    MarkDelivered event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _apiService.dio.put('${ApiConstants.orders}/${event.id}/delivered');
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadAllReviews(
    LoadAllReviews event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      final response = await _apiService.dio.get('/api/reviews');
      final reviews = response.data['reviews'] as List<dynamic>;
      emit(AdminReviewsLoaded(reviews));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _apiService.dio.put(
        '/api/products/${event.productId}/${event.reviewId}',
      );
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<AdminState> emit,
  ) async {
    emit(AdminLoading());
    try {
      await _productService.updateProduct(event.id, event.data);
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onAddProduct(AddProduct event, Emitter<AdminState> emit) async {
    emit(AdminLoading());
    try {
      await _productService.addProduct(event.data);
      emit(AdminActionSuccess());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
