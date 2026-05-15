import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // Adjust this to your machine's IP for physical devices or 10.0.2.2 for Android emulators
    baseUrl: 'http://kcs-mobile.test/api',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  final _storage = const FlutterSecureStorage();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    await _storage.write(key: 'auth_token', value: response.data['access_token']);
    return response.data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
    });
    await _storage.write(key: 'auth_token', value: response.data['access_token']);
    return response.data;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (e) {
      // Ignore API errors on logout (e.g., token already expired)
    } finally {
      await _storage.delete(key: 'auth_token');
    }
  }

  Future<User> getMe() async {
    final response = await _dio.get('/user');
    return User.fromJson(response.data['data']);
  }

  // Menu & Products
  Future<List<Category>> getMenu() async {
    final response = await _dio.get('/menu');
    return (response.data['data'] as List)
        .map((c) => Category.fromJson(c))
        .toList();
  }

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/products');
    return (response.data['data'] as List)
        .map((p) => Product.fromJson(p))
        .toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await _dio.get('/products/$id');
    return Product.fromJson(response.data['data']);
  }

  Future<void> updateProductStatus(int id, bool isAvailable) async {
    await _dio.patch('/products/$id', data: {'is_available': isAvailable});
  }

  Future<List<Modifier>> getModifiers() async {
    final response = await _dio.get('/modifiers');
    return (response.data['data'] as List)
        .map((m) => Modifier.fromJson(m))
        .toList();
  }

  // Locations
  Future<List<Barangay>> getBarangays() async {
    final response = await _dio.get('/barangays');
    return (response.data['data'] as List)
        .map((b) => Barangay.fromJson(b))
        .toList();
  }

  // Orders
  Future<Map<String, dynamic>> placeOrder({
    required List<Map<String, dynamic>> items,
    String? addressText,
  }) async {
    final response = await _dio.post('/orders', data: {
      'items': items,
      'address_text': addressText,
    });
    return response.data;
  }

  Future<List<dynamic>> getOrders() async {
    final response = await _dio.get('/orders');
    return response.data['data'];
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await _dio.patch('/orders/$orderId/status', data: {'status': status});
  }
}
