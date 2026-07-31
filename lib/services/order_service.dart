import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import 'api_service.dart';

class OrderResult {
  final bool success;
  final String message;
  final OrderModel? order;

  OrderResult({required this.success, required this.message, this.order});
}

class OrderService {
  Future<List<OrderModel>> getOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.orders),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<OrderResult> createOrder({
    required String token,
    required String customerName,
    required String phone,
    required String address,
    required double latitude,
    required double longitude,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'customer_name': customerName,
          'phone': phone,
          'address': address,
          'latitude': latitude,
          'longitude': longitude,
          'items': items,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return OrderResult(
          success: true,
          message: 'Pesanan berhasil dibuat',
          order: OrderModel.fromJson(data),
        );
      } else {
        String errorMsg = data['message'] ?? 'Gagal membuat pesanan';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMsg = errors.values.first[0];
        }
        return OrderResult(success: false, message: errorMsg);
      }
    } catch (e) {
      return OrderResult(
        success: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }

  /// Mengubah Status Pesanan (Admin / Pemilik Toko)
  Future<bool> updateOrderStatus({
    required String token,
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.orders}/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
