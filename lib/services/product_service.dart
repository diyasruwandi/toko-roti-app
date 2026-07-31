import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.products),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat produk. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<ProductModel?> createProduct({
    required String token,
    required String name,
    String? description,
    required double price,
    String? image,
    required int stock,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.products),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'image': image,
          'stock': stock,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productData = data['product'] ?? data;
        return ProductModel.fromJson(productData);
      }
      return null;
    } catch (e) {
      print('Error createProduct: $e');
      return null;
    }
  }

  Future<ProductModel?> updateProduct({
    required String token,
    required int id,
    required String name,
    String? description,
    required double price,
    String? image,
    required int stock,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.products}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'image': image,
          'stock': stock,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productData = data['product'] ?? data;
        return ProductModel.fromJson(productData);
      }
      return null;
    } catch (e) {
      print('Error updateProduct: $e');
      return null;
    }
  }

  Future<bool> deleteProduct({
    required String token,
    required int id,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.products}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleteProduct: $e');
      return false;
    }
  }
}
